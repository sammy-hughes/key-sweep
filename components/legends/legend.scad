include <./config.scad>;

module print_symbol(base_symbol, size=$LEGEND_BASE_WIDTH, depth=$LEGEND_DEPTH, fit_to_size=$LEGEND_FIT_WIDTH, cavity=$LEGEND_CAVITY) {
  actual_size = len(base_symbol)*size;
  effective_size=min(fit_to_size, actual_size);
  size_ratio=effective_size/depth;
  
  module base_symbol() {
    scale_factor=(actual_size > fit_to_size? fit_to_size/actual_size: 1);
    
    scale([scale_factor, scale_factor, 1])
    text(
      base_symbol, 
      size, 
      halign="center", 
      valign="center",
      font="Arial Rounded MT Bold"
    );
  }
  
  intersection() {
    linear_extrude(height=depth*2, scale=1.05, center=true)
    base_symbol();
    
    if (actual_size>size) {
      hull() {
        for (i=[-1:1:1])
        translate([i*effective_size/2, 0, abs(i)*size])
        scale([size_ratio, size_ratio, 1])
        sphere(r=depth);
      }
    } else {
      scale([size_ratio, size_ratio, 1])
      sphere(r=depth);
    }
  }
}
