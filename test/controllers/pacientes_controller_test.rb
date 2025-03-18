require "test_helper"

class PacientesControllerTest < ActionDispatch::IntegrationTest
  test "should get paciente" do
    get pacientes_paciente_url
    assert_response :success
  end
end
