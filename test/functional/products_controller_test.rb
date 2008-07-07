require File.dirname(__FILE__) + '/../test_helper'

class ProductsControllerTest < ActionController::TestCase

  def setup
    login_as :quentin
    super

    @product = Product.create!(:name => "Product")
    @required_params = { :name => "Another product" }
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_product
    assert_difference('Product.count') do
      post :create, :product => @required_params
    end

    assert_redirected_to product_path(assigns(:product))
  end

  def test_should_show_product
    get :show, :id => @product.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @product.id
    assert_response :success
  end

  def test_should_update_product
    put :update, :id => @product.id, :product => { }
    assert_redirected_to product_path(assigns(:product))
  end

  def test_should_destroy_product
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.id
    end

    assert_redirected_to products_path
  end
end
