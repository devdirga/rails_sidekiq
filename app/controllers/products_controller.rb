class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :authenticate_user!

  # GET /products
  def index
    # Use `params[:page]` to handle pagination with `kaminari`
    @products = Product.page(params[:page]).per(10) # 10 items per page

    render json: {
      data: ProductSerializer.new(@products).serializable_hash[:data],
      meta: pagination_meta(@products)
    }
  end

  # GET /products/:id
  def show
    render json: ProductSerializer.new(@product).serializable_hash
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PUT /products/:id
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  private

  # Set product for show, update, and destroy actions
  def set_product
    @product = Product.find(params[:id])
  end

  # Strong parameters for creating/updating products
  def product_params
    params.require(:product).permit(:name, :description, :price)
  end

  def pagination_meta(products)
    {
      current_page: products.current_page,
      next_page: products.next_page,
      prev_page: products.prev_page,
      total_pages: products.total_pages,
      total_count: products.total_count
    }
  end
end
