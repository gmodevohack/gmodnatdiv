/* punked from http://terra-firma-design.com/blog/16-Rails-Form-With-Multiple-Attributes */

Stock = {
  addStock: function(current_stock_index) {
    current_stock_index++;
    $('add_stock').remove();
    new_stock = '<li id="stocks_' + current_stock_index + '">\n';
    new_stock += '<label for="stocks_'+ current_stock_index + '_name" class="inline">Stock:</label>\n';
    new_stock += '<input class="text" id="stocks_' + current_stock_index + '_name" name="stocks[' + current_stock_index + '][name]" stock="30" type="text" />\n';
    new_stock += '<a href="#" title="Delete stock" onclick="Stock.removeStock(\'stocks_' + current_stock_index + '\');">X</a>\n';
    new_stock += '<a href="#" title="Add another stock" onclick="Stock.addStock(' + current_stock_index + ');return false;" id="add_stock">add another stock</a>\n';
    new_stock += '</li>\n';
    $('stocks').insert(new_stock);
  },
  
  removeStock: function(stock) {
    target_stock = $(stock);
    target_index = parseInt(stock.split('_')[1]);
    current_stocks = target_stock.parentNode.getElementsByTagName('li');
    total_current_stocks = current_stocks.length;
    if (total_current_stocks > 1) {
      if (target_stock.getAttribute('id') == current_stocks[(total_current_stocks - 1)].getAttribute('id')) {
        current_stocks[(total_current_stocks - 2)].insert('<a href="#" title="Add another stock" onclick="Stock.addStock(' + target_index + ');return false;" id="add_stock">add another stock</a>\n');
      }
      target_stock.remove();
    } else {
      alert('There has to be at least one stock.');
    }
  }
}



