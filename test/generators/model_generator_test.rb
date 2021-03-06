require 'test_helper'
require 'generators/ember/model_generator'

class ModelGeneratorTest < Rails::Generators::TestCase
  include GeneratorTestSupport

  tests Ember::Generators::ModelGenerator
  destination File.join(Rails.root, "tmp", "generator_test_output")

  setup :prepare_destination

  test "create model" do
    run_generator ["post", "title:string"]
    assert_file "#{app_path}/models/post.es6"
  end

  test "create namespaced model" do
    run_generator ["post/dog", "title:string"]
    assert_file "#{app_path}/models/post/dog.es6"
  end

  test "leave parentheses when create model w/o attributes" do
    run_generator ["post"]
    assert_file "#{app_path}/models/post.es6", /export default DS.Model.extend/
  end

  test "forces pluarl names to singular" do
    run_generator ["posts"]
    assert_file "#{app_path}/models/post.es6"
    assert_no_file "#{app_path}/models/posts.es6"
  end

  test "Assert files are properly created" do
    run_generator %w(ember)

    assert_file "#{app_path}/models/ember.es6"
  end

  test "Uses config.ember.appkit.paths.app" do
    custom_path = app_path("custom")

    with_config paths: {app: custom_path} do
      run_generator ["ember"]
      assert_file "#{custom_path}/models/ember.es6"
    end
  end

  test "create test" do
    run_generator ["post", "title:string"]
    assert_file "test/models/post_test.es6"
  end

  test "imports model for test" do
    run_generator ["post", "title:string"]

    assert_file 'test/models/post_test.es6', /^import Post from 'app\/models\/post';$/
  end

  test "create namespaced test" do
    run_generator ["post/dog", "title:string"]
    assert_file "test/models/post/dog_test.es6"
  end

  test "imports namespaced model for test" do
    run_generator ["post/dog", "title:string"]

    assert_file 'test/models/post/dog_test.es6', /^import Dog from 'app\/models\/post\/dog';$/
  end
end
