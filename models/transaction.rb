require_relative('../db/sql_runner.rb')

class Transaction
  attr_reader :id, :amount, :date_of_transaction, :comment, :wallet_id, :shop_id, :category_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_f.round(2)
    @date_of_transaction = options['date_of_transaction']
    @comment = options['comment']
    @wallet_id = 1
    @shop_id = options['shop_id'].to_i
    @category_id = options['category_id'].to_i
  end

  def save
    sql = "INSERT INTO transactions (amount, date_of_transaction, comment, wallet_id, shop_id, category_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *"
    values = [@amount, @date_of_transaction, @comment, @wallet_id, @shop_id, @category_id]
    @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def update
    sql = "UPDATE transactions SET (amount, date_of_transaction, comment, wallet_id, shop_id, category_id) = ($1, $2, $3, $4, $5, $6) WHERE id=$7"
    values = [@amount, @date_of_transaction, @comment, @wallet_id, @shop_id, @category_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM transactions ORDER BY date_of_transaction DESC"
    transactions = SqlRunner.run(sql)
    result = transactions.map {|transaction| Transaction.new(transaction)}
  end

  def self.last_five()
    sql = "SELECT * FROM transactions ORDER BY date_of_transaction DESC LIMIT 5"
    transactions = SqlRunner.run(sql)
    result = transactions.map {|transaction| Transaction.new(transaction)}
  end

  def delete
    sql = "DELETE FROM transactions WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  def shop
    sql = "SELECT * FROM shops WHERE id = $1"
    values = [@shop_id]
    shop = SqlRunner.run(sql, values).first
    return Shop.new(shop)
  end

  def category
    sql = "SELECT * FROM categories WHERE id = $1"
    values = [@category_id]
    category = SqlRunner.run(sql, values).first
    return Category.new(category)
  end

  def self.find(id)
    sql = "SELECT * FROM transactions where id = $1"
    values = [id]
    transaction = SqlRunner.run(sql, values).first
    return Transaction.new(transaction)
  end

  def self.transactions_by_month_number(year_id, month_id)
    sql="SELECT * FROM transactions WHERE EXTRACT(YEAR FROM date_of_transaction)=$1 AND EXTRACT(MONTH FROM date_of_transaction)=$2 ORDER BY date_of_transaction DESC"
    values = [year_id, month_id]
    transactions = SqlRunner.run(sql, values)
    result = transactions.map {|transaction| Transaction.new(transaction)}
  end

  def self.total_by_month(year_id,month_id)
    sql="SELECT SUM(amount) FROM transactions WHERE EXTRACT(YEAR FROM date_of_transaction)=$1 AND EXTRACT(MONTH FROM date_of_transaction)=$2"
    values = [year_id, month_id]
    total = SqlRunner.run(sql, values).first['sum']
    return total if total
    else return 0
  end

  def self.last_five_transactions_by_month_number(year_id, month_id)
    sql="SELECT * FROM transactions WHERE EXTRACT(YEAR FROM date_of_transaction)=$1 AND EXTRACT(MONTH FROM date_of_transaction)=$2 ORDER BY date_of_transaction DESC LIMIT 5"
    values = [year_id, month_id]
    transactions = SqlRunner.run(sql, values)
    result = transactions.map {|transaction| Transaction.new(transaction)}
  end

end
