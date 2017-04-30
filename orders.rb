# order methods
# add order to the database
# update order 

require_relative 'order.rb'


def add_order(db,username, pizza, date)
    
    status = "unconfirmed"
    no_of_rows = db.get_first_value(
        'SELECT COUNT(*) FROM orders')
    
    order_id = no_of_rows.to_i + 1
    db.execute(
        'INSERT INTO orders VALUES (?, ?, ?, ?, ?)',
        [order_id, username, pizza, status, date])
    
end

def add_feedback_tweet(db, username, message, date)
    db.execute(
        'INSERT INTO feedback VALUES (?, ?, ?)',
        [date, username, message])
end

def get_no_of_orders(db)
    no_of_rows = db.get_first_value(
        'SELECT COUNT(*) FROM orders')
    return no_of_rows.to_i
    
end

def get_no_of_feedback(db)
    no_of_rows = db.get_first_value(
        'SELECT COUNT(*) FROM feedback')
    return no_of_rows.to_i
    
end

def update_order_confirm(db, username, confirmation_date)
    status = "confirmed"
    if(get_no_of_orders(db)!=0)
        order_date = db.get_first_value('SELECT Date FROM orders WHERE TwitterUsername = ?', [username])
        order_date = DateTime.parse(order_date.to_s)
        confirmation_date = DateTime.parse(confirmation_date)
        if(confirmation_date > order_date)
            db.execute(
                'UPDATE orders SET Status = ? WHERE TwitterUsername = ?',
                [status, username])
        end
    end

end

def update_order_accept(db, date)
    status = "accepted"
    puts "got to accept order method"
    id = 1
    puts id
    id = id.to_i
    db.execute(
        'UPDATE orders SET Status = ? WHERE Date = ?',
        [status, date])
end

def delete_order(db, id)
   
    id = id.to_i
    db.execute(
        'DELETE FROM orders WHERE OrderID = ?', 
        [id])
end

def update_order_id(db)
    no_of_orders = get_no_of_orders(db)
    for i in 1..no_of_orders
        db.execute(
        'UPDATE orders SET OrderID = ? WHERE OrderID = ?',
        [i, i+1])
    end
            
end

def get_processing_orders(db)
    no_of_orders = get_no_of_orders(db)

    orders = Array.new
    
    for i in 0...no_of_orders
        id = i + 1
        username = db.get_first_value('SELECT TwitterUsername FROM orders WHERE OrderID = ?', [id])
        pizza = db.get_first_value('SELECT Pizza FROM orders WHERE OrderID = ?', [id])
        status = db.get_first_value('SELECT Status FROM orders WHERE OrderID = ?', [id])
        date = db.get_first_value('SELECT Date FROM orders WHERE OrderID = ?', [id])
        order = Order.new(id,username, pizza, status, date)
        orders.push(order)
        
    end
    
    return orders
        
end

def get_feedback_tweets(db)
    
    no_of_feedback = get_no_of_feedback(db)

    feedback = Array.new
    
    feedback = db.execute('SELECT * FROM feedback')
    puts "got to the feedback method"
    return feedback
    
    
end
