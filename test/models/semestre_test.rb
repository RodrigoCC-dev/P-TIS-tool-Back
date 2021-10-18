require 'test_helper'

class SemestreTest < ActiveSupport::TestCase
  test "Semestre con identificador existente no se guarda" do
    semestre = Semestre.new(
      numero: 2,
      agno: 2021,
      inicio: '2021-10-19 01:03:25',
      fin: '2021-12-19 20:00:00'
    )
    assert_not semestre.save
  end

  test "Semestre con nuevo identificador se guarda" do
    semestre = Semestre.new(
      numero: 1,
      agno: 2021,
      inicio: '2021-04-19 01:03:25',
      fin: '2021-07-19 20:00:00'
    )
    assert semestre.save
  end

  test "Semestre con identificador con formato incorrecto no se guarda" do
    semestre = Semestre.new(
      numero: 3,
      agno: 221,
      inicio: '2021-10-19 01:03:25',
      fin: '2021-12-19 20:00:00'
    )
    assert_not semestre.save
  end
end
