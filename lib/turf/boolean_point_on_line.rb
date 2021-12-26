# frozen_string_literal: true

#:nodoc:
module Turf
  # @!group Booleans

  # Takes a Point and a LineString and determines if the point resides one the lineString.
  def boolean_point_on_line(point, line)
    # Normalize inputs
    point_coords = get_coord(point);
    line_coords = get_coords(line);

    # Main
    (0..line_coords.count - 2).to_a.each_with_index do |index|
      return true if is_point_on_line_segment(line_coords[index], line_coords[index + 1], point_coords, false)
    end
    return false
  end

  private

  def is_point_on_line_segment(line_segment_start, line_segment_end, point, exclude_boundary)
    x = point[0];
    y = point[1];
    x1 = line_segment_start[0];
    y1 = line_segment_start[1];
    x2 = line_segment_end[0];
    y2 = line_segment_end[1];
    dxc = point[0] - x1;
    dyc = point[1] - y1;
    dxl = x2 - x1;
    dyl = y2 - y1;
    cross = dxc * dyl - dyc * dxl;

    return false if cross != 0

    if !exclude_boundary
      if dxl.abs >= dyl.abs
        return dxl > 0 ? x1 <= x && x <= x2 : x2 <= x && x <= x1;
      end
      return dyl > 0 ? y1 <= y && y <= y2 : y2 <= y && y <= y1;
    end
    return false;
  end
end
