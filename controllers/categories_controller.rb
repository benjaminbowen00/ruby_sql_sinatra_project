require('pry-byebug')
require('sinatra')
require('sinatra/reloader')
require_relative('../models/category.rb')
require_relative('../models/shop.rb')
require_relative('../models/transaction.rb')
require_relative('../models/wallet.rb')


get '/categories' do
  @categories = Category.all()
  @wallet = Wallet.find(1)
  @wallet.update
  erb (:'category_views/categories')
end

get '/categories/:id/transactions' do
    @category = Category.find(params[:id])
    @transactions = Category.category_transactions_year_month(params[:id])
    erb (:'category_views/category_transactions')
end

get '/categories/:id/edit' do
  @category = Category.find(params[:id])
  erb (:'category_views/category_edit')
end

put '/categories/:id' do
  category = Category.new(params).update
  redirect to '/categories'
end

get '/categories/:id/warning' do
  @category = Category.find(params[:id])
  @transactions = Category.category_transactions_year_month(params[:id])
  erb (:'category_views/category_warning')
end

get '/categories/new' do
  erb (:'category_views/category_new')
end

post '/categories' do
  category = Category.new(params).save
  redirect to '/categories'
end

delete '/categories/:id' do
  Category.new(params).delete
  redirect to '/categories'
end

get '/categories/current' do
  date = DateMonth.new
  @month = date.month
  @year = date.year
  @categories = Category.all()
  @monthly_spend = Transaction.total_by_month(@year, @month)
  erb (:'category_views/categories_current')
end

get '/categories/current/:id/transactions' do
  date = DateMonth.new
  @month = date.month
  @year = date.year
  @category = Category.find(params[:id])
  @transactions = Category.category_transactions_year_month(params[:id], @year, @month)
  erb (:'category_views/categories_current_transactions')
end
