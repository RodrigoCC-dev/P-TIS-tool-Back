require 'test_helper'

class StakeholderTest < ActiveSupport::TestCase
  test "Stakeholder sin 'iniciales' no se guarda" do
    stakeholder = Stakeholder.new(
      usuario_id: usuarios(:one).id,
      grupo_id: grupos(:one).id
    )
    assert_not stakeholder.save
  end

  test "Stakeholder con iniciales se guarda" do
    stakeholder = Stakeholder.new(
      iniciales: 'ABC',
      usuario_id: usuarios(:one).id,
      grupo_id: grupos(:one).id
    )
    assert stakeholder.save
  end
end
