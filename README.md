# Stylized Sky

A reusable stylized sky addon for Godot 4.7 (GL Compatibility), authored as a
**visual shader** graph so the look is editable as nodes, not as an opaque blob.

- `addons/stylized_sky/sky_graph.tres` - the sky VisualShader (mode: Sky). Edit this.
- `addons/stylized_sky/sky_material.tres` - ShaderMaterial wrapping the graph.
- `addons/stylized_sky/plugin.gd` - registers custom visual shader nodes.
- `demo/sky_demo.tscn` - preview scene: camera, horizon plane, WorldEnvironment.

Open `demo/sky_demo.tscn` and double-click `sky_graph.tres` to author the sky.
