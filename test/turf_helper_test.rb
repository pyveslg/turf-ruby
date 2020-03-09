# frozen_string_literal: true

require "test_helper"

class TurfHelperTest < Minitest::Test
  def test_line_string
    line = Turf.line_string([[5, 10], [20, 40]], name: "test line")
    assert_equal(line[:geometry][:coordinates][0][0], 5)
    assert_equal(line[:geometry][:coordinates][1][0], 20)
    assert_equal(line[:properties][:name], "test line")
    assert_equal(
      Turf.line_string([[5, 10], [20, 40]])[:properties],
      {},
      "no properties case",
    )

    assert_raises(ArgumentError, "error on no coordinates") { Turf.line_string }
    exception = assert_raises(Turf::Error) do
      Turf.line_string([[5, 10]])
    end
    assert_equal(
      exception.message,
      "coordinates must be an array of two or more positions",
    )
    assert_raises(Turf::Error, "coordinates must contain numbers") do
      Turf.line_string([["xyz", 10]])
    end
    assert_raises(Turf::Error, "coordinates must contain numbers") do
      Turf.line_string([[5, "xyz"]])
    end
  end

  def test_point
    pt_array = Turf.point([5, 10], name: "test point")

    assert_equal(pt_array[:geometry][:coordinates][0], 5)
    assert_equal(pt_array[:geometry][:coordinates][1], 10)
    assert_equal(pt_array[:properties][:name], "test point")

    no_props = Turf.point([0, 0])
    assert_equal(no_props[:properties], {}, "no props becomes {}")
  end

  def test_units
    units = Turf.units("kilometers")
    assert_equal(units, "kilometers")

    assert_raises(Turf::Error, "invalid units: kilograms") do
      Turf.units("kilograms")
    end
  end

  def test_degrees_to_radians
    [
      [60, Math::PI / 3],
      [270, 1.5 * Math::PI],
      [-180, -Math::PI],
    ].each do |degrees, radians|
      assert_equal radians, Turf.degrees_to_radians(degrees)
    end
  end

  def test_radians_to_length
    [
      [1, "radians", 1],
      [1, "kilometers", Turf::EARTH_RADIUS / 1000],
      [1, "miles", Turf::EARTH_RADIUS / 1609.344],
    ].each do |radians, units, length|
      assert_equal length, Turf.radians_to_length(radians, units)
    end
  end

  def test_length_to_radians
    [
      [1, "radians", 1],
      [Turf::EARTH_RADIUS / 1000, "kilometers", 1],
      [Turf::EARTH_RADIUS / 1609.344, "miles", 1],
    ].each do |length, units, radians|
      assert_equal radians, Turf.length_to_radians(length, units)
    end
  end
end
