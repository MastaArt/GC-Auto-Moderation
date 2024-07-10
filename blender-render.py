# Blender Auto Render
# 1.0.0
# Vasyl Lukianenko 
# 3DGROUND
# https://3dground.net

import bpy
import math
import os
import glob

# Define time limit for rendering (in seconds)
max_samples = 12
scene = bpy.context.scene
obj = bpy.ops.object
blend_file_path = bpy.data.filepath
blend_filename = os.path.basename(blend_file_path)
blend_dirname = os.path.dirname(blend_file_path)
blend_filename_no_ext = os.path.splitext(blend_filename)[0]
render_file_name = f"{blend_file_path}.png"
texture_dir = f"{blend_dirname}/**/*.*"

# Find missing tex
def find_missing_tex():
    files_lookup = {}
    for p in glob.glob(texture_dir, recursive=True):
        files_lookup[os.path.basename(p)] = p

    dirty = False
    os.chdir(blend_dirname)
    for image in bpy.data.images.values():
        if image.source == "FILE":
            # Make absolute
            if image.filepath[:2] == "//":
                path = os.path.abspath(image.filepath[2:])
            else:
                path = image.filepath
            
            # Check if file does not exist
            if not os.path.exists(path):
                name = os.path.basename(path)                
                if name in files_lookup:
                    image.filepath = "//" + os.path.relpath(files_lookup[name])
                    dirty = True
    
find_missing_tex()

# Render settings
def setup_render():
   # if scene.render.engine == 'CYCLES':
   #     scene.cycles.progressive = 'PATH'
   #     scene.cycles.samples = 20
   # elif scene.render.engine == 'BLENDER_EEVEE':
   #     scene.eevee.taa_render_samples = 20

    scene.render.engine = 'CYCLES'
    scene.cycles.progressive = 'PATH'
    scene.cycles.samples = max_samples
    scene.render.resolution_x = 1024
    scene.render.resolution_y = 1024
    scene.render.film_transparent = True
    #scene.render.image_settings.file_format = 'JPEG'
    #scene.render.image_settings.quality = 90  # JPEG quality (0 to 100)
    scene.render.filepath = render_file_name
    if os.path.exists(render_file_name):
        os.remove(render_file_name)

render_file = setup_render()

# Create and configure camera
def setup_camera():
    obj.select_all(action='DESELECT')
    obj.select_by_type(type='CAMERA')
    obj.delete()
    obj.camera_add(location=(0, 5, 5)) 
    camera = bpy.context.object
    camera.rotation_mode = 'XYZ'
    camera.rotation_euler = (math.radians(60), 0, math.radians(10))
    scene.camera = camera
    obj.select_all(action='SELECT')
    bpy.ops.view3d.camera_to_view_selected()
    camera.data.lens *= 0.95
    return camera

camera = setup_camera()

# Create and configure light source (point light behind the camera)
def setup_light():
    obj.select_all(action='DESELECT')
    obj.light_add(type='POINT', location=(0, -8, 8))
    light = bpy.context.object
    light.data.energy = 100  # Adjust light intensity as needed
    return light

light_source = setup_light()

try:
# Enable Skylight
    scene.world.use_nodes = True
    bg_node = scene.world.node_tree.nodes.new(type='ShaderNodeTexSky')
    output_node = scene.world.node_tree.nodes['Background']
    scene.world.node_tree.links.new(bg_node.outputs['Color'], output_node.inputs['Color'])
except:
    print("Can't setup background.")
    


# Start rendering
try:
    bpy.ops.render.render(write_still=True)
except:
    print("Render stopped due to time limit or other interruption.")

print("Render completed or stopped.")
