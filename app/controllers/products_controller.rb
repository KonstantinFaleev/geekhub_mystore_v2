class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    #@products = Product.all
    @products = Product.order("title").page(params[:page]).per(3)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    set_meta_tags title: 'Member Login',
                  description: 'Member login page.',
                  keywords: 'Site, Login, Members'
    #@category = Category.find(params[:category_id])
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all.map{ |c| [c.name, c.id] }
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.category_id = params[:category_id]

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product.category_id = params[:category_id]
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }

        @products = Product.all
        ActionCable.server.broadcast 'products', html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :category, {images: []})
    end
end
