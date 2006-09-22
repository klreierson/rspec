require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ExecutionContextTest < Test::Unit::TestCase

      def test_should_add_new_mock_to_spec_when_mock_message_received
        spec = Spec::Mocks::Mock.new "spec"
        spec.should_receive(:add_mock) {|mock| mock.instance_of? Spec::Mocks::Mock}
        ec = ExecutionContext.new spec
        mock = ec.mock("a mock", :null_object=>true)
      end

      def test_stub__should_stub_object_with_a_method
        spec = Spec::Mocks::Mock.new "spec"
        stub_space = Spec::Mocks::Mock.new "stub_space"
        spec.should_receive(:stub_space) {stub_space}
        target = Object.new
        name = "foobar"
        expected_stub = Object.new
        stub_space.
          should_receive(:create_stub).
          once.
          with(target, name).
          and_return {expected_stub}
        ec = ExecutionContext.new spec
        stub = ec.stub(target, name)
        assert_equal expected_stub, stub
      end
      
      def test_violated
        assert_raise(Spec::Expectations::ExpectationNotMetError) do
          ExecutionContext.new(nil).violated
        end
      end
      
      def test_duck_type
        ec = ExecutionContext.new(Spec::Mocks::Mock.new("spec", :null_object => true))
        duck_type = ec.duck_type(:length)
        assert duck_type.is_a?(Spec::Mocks::DuckTypeArgConstraint)
        assert duck_type.matches?([])
      end
    end
  end
end