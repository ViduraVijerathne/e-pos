import 'package:point_of_sale/utils/database.dart';

import '../widget/my_line_chart_widget.dart';

class ChartController {
  Future<DateTime> getInvoiceDbMinDate() async {
    String query = "SELECT MIN(invoice.invoice_date) AS date FROM invoice";
    var pool = MySQLDatabase().pool;
    var result = await pool.execute(query);

    return DateTime.parse(result.rows.first.colByName('date').toString());
  }

  Future<DateTime> getInvoiceDbMaxDate() async {
    String query = "SELECT MAX(invoice.invoice_date) AS date FROM invoice";
    var pool = MySQLDatabase().pool;
    var result = await pool.execute(query);

    return DateTime.parse(result.rows.first.colByName('date').toString());
  }

  Future<List<double>> _daily(String query) async {
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    DateTime marginDate = minDate;
    data.add(0);
    for (int i = minDate.day; i <= maxDate.day; i++) {
      String q = query;
      q = q.replaceAll(":minDate", marginDate.toIso8601String());
      print("FROM Date ${marginDate.toIso8601String()}");
      marginDate = marginDate.add(Duration(days: 1));
      print("TO Date ${marginDate.toIso8601String()}");

      q = q.replaceAll(":maxDate", marginDate.toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;
      print(q);
      print("ROW Count is ${results.rows.length}");
      if (results.rows.isNotEmpty) {
        sum = double.parse(results.rows.first.colByName("res") == null
            ? "0"
            : results.rows.first.colByName("res") as String);
        data.add(sum);
        print("Sum${sum} ");
      }

      // print(query);
    }
    data.add(0);

    print(data);
    return data;
  }
  Future<List<double>> _weekly(String query) async {
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);

    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 6)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;
      print(q);

      if (results.rows.isNotEmpty) {
        sum = double.parse(results.rows.first.colByName("res") == null
            ? "0"
            : results.rows.first.colByName("res") as String);
        data.add(sum);
      }
      minDate = minDate.add(Duration(days: 7));
      dateCount = dateCount - 7;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _monthly(String query) async {
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);

    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 30)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;
      print(q);

      if (results.rows.isNotEmpty) {
        sum = double.parse(results.rows.first.colByName("res") == null
            ? "0"
            : results.rows.first.colByName("res") as String);
        data.add(sum);
      }
      minDate = minDate.add(Duration(days: 30));
      dateCount = dateCount - 30;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _yearly(String query)async{
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);

    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 365)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;
      print(q);

      if (results.rows.isNotEmpty) {
        sum = double.parse(results.rows.first.colByName("res") == null
            ? "0"
            : results.rows.first.colByName("res") as String);
        data.add(sum);
      }
      minDate = minDate.add(Duration(days: 365));
      dateCount = dateCount - 365;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _total(String query) async{
    List<double> data = [];
    var pool = MySQLDatabase().pool;
    var results = await pool.execute(query);
    data.add(0);
    for (var row in results.rows) {
      data.add(double.parse(row.colByName("res") == null
          ? "0"
          : row.colByName("res") as String));
    }
    data.add(0);
    return data;
  }

  Future<List<double>> _dailyProfit(String query) async {
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    DateTime marginDate = minDate;
    data.add(0);

    for (int i = minDate.day; i <= maxDate.day; i++) {
      String q = query;
      q = q.replaceAll(":minDate", marginDate.toIso8601String());
      print("FROM Date ${marginDate.toIso8601String()}");
      marginDate = marginDate.add(Duration(days: 1));
      print("TO Date ${marginDate.toIso8601String()}");

      q = q.replaceAll(":maxDate", marginDate.toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;

      for(var row in results.rows){
        double qty = double.parse(row.colByName("qty") == null ? '0' : row.colByName("qty") as String);
        double unitWholeSalePrice = double.parse(row.colByName("wholesalePrice") == null ? '0' : row.colByName("wholesalePrice") as String);
        double unitPrice = double.parse(row.colByName("unitPrice") == null ? '0' : row.colByName("unitPrice") as String);
        double discount = double.parse(row.colByName("discount") == null ? '0' : row.colByName("discount") as String);

        double profit = (unitPrice -unitWholeSalePrice  - discount)*qty;
        print("${profit} = (${unitPrice} - ${unitWholeSalePrice} - ${discount})*${qty}");
        data.add(profit);
      }
      print("===============================");

      // print(query);
    }
    data.add(0);

    print(data);
    return data;
  }
  Future<List<double>> _weeklyProfit(String query) async {
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);

    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 6)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;

      for(var result in results.rows){
        double qty = double.parse(result.colByName("qty") == null ? '0' : result.colByName("qty") as String);
        double unitWholeSalePrice = double.parse(result.colByName("wholesalePrice") == null ? '0' : result.colByName("wholesalePrice") as String);
        double unitPrice = double.parse(result.colByName("unitPrice") == null ? '0' : result.colByName("unitPrice") as String);
        double discount = double.parse(result.colByName("discount") == null ? '0' : result.colByName("discount") as String);

        double profit = (unitPrice -unitWholeSalePrice  - discount)*qty;
        print("${profit} = (${unitPrice} - ${unitWholeSalePrice} - ${discount})*${qty}");
        sum += profit;
      }

      data.add(sum);



      minDate = minDate.add(Duration(days: 7));
      dateCount = dateCount - 7;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _monthlyProfit(String query) async{
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);
    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 30)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;

      for(var result in results.rows){
        double qty = double.parse(result.colByName("qty") == null ? '0' : result.colByName("qty") as String);
        double unitWholeSalePrice = double.parse(result.colByName("wholesalePrice") == null ? '0' : result.colByName("wholesalePrice") as String);
        double unitPrice = double.parse(result.colByName("unitPrice") == null ? '0' : result.colByName("unitPrice") as String);
        double discount = double.parse(result.colByName("discount") == null ? '0' : result.colByName("discount") as String);

        double profit = (unitPrice -unitWholeSalePrice  - discount)*qty;
        print("${profit} = (${unitPrice} - ${unitWholeSalePrice} - ${discount})*${qty}");
        sum += profit;
      }

      data.add(sum);



      minDate = minDate.add(Duration(days: 30));
      dateCount = dateCount - 30;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _yearlyProfit(String query) async{
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);
    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 365)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;

      for(var result in results.rows){
        double qty = double.parse(result.colByName("qty") == null ? '0' : result.colByName("qty") as String);
        double unitWholeSalePrice = double.parse(result.colByName("wholesalePrice") == null ? '0' : result.colByName("wholesalePrice") as String);
        double unitPrice = double.parse(result.colByName("unitPrice") == null ? '0' : result.colByName("unitPrice") as String);
        double discount = double.parse(result.colByName("discount") == null ? '0' : result.colByName("discount") as String);

        double profit = (unitPrice -unitWholeSalePrice  - discount)*qty;
        print("${profit} = (${unitPrice} - ${unitWholeSalePrice} - ${discount})*${qty}");
        sum += profit;
      }

      data.add(sum);



      minDate = minDate.add(Duration(days: 365));
      dateCount = dateCount - 365;
    }
    data.add(0);

    return data;
  }
  Future<List<double>> _totalProfit(String query) async{
    List<double> data = [];
    DateTime maxDate = await getInvoiceDbMaxDate();
    DateTime minDate = await getInvoiceDbMinDate();

    // get date count in defferent between max date and min date
    int dateCount = maxDate.difference(minDate).inDays;
    data.add(0);
    while (dateCount > 0){
      String q = query;
      q = q.replaceAll(":minDate", minDate.toIso8601String());
      q = q.replaceAll(":maxDate", minDate.add(Duration(days: 1)).toIso8601String());
      var pool = MySQLDatabase().pool;
      var results = await pool.execute(q);
      double sum = 0;

      for(var result in results.rows){
        double qty = double.parse(result.colByName("qty") == null ? '0' : result.colByName("qty") as String);
        double unitWholeSalePrice = double.parse(result.colByName("wholesalePrice") == null ? '0' : result.colByName("wholesalePrice") as String);
        double unitPrice = double.parse(result.colByName("unitPrice") == null ? '0' : result.colByName("unitPrice") as String);
        double discount = double.parse(result.colByName("discount") == null ? '0' : result.colByName("discount") as String);

        double profit = (unitPrice -unitWholeSalePrice  - discount)*qty;
        print("${profit} = (${unitPrice} - ${unitWholeSalePrice} - ${discount})*${qty}");
        sum += profit;
      }

      data.add(sum);



      minDate = minDate.add(Duration(days: 1));
      dateCount = dateCount - 1;
    }
    data.add(0);

    return data;
  }


  Future<List<double>> _sales(InsightTimes time) async {
    List<double> data = [];
    String q =
        "SELECT SUM(invoice.invoice_grand_total) AS `res` FROM invoice WHERE invoice.invoice_date >= ':minDate' AND invoice.invoice_date < ':maxDate' ORDER BY invoice.invoice_date ASC";

    if (time == InsightTimes.daily) {
      data.addAll(await _daily(q));
    }

    if (time == InsightTimes.weekly) {
      data.addAll(await _weekly(q));
    }
    if (time == InsightTimes.monthly) {
      data.addAll(await _monthly(q));
    }

    if (time == InsightTimes.yearly) {
      data.addAll(await _yearly(q));
    }
    if(time == InsightTimes.total){
      data.addAll(await _total("SELECT invoice.invoice_grand_total AS `res`  FROM invoice "));
    }

    return data;
  }

  Future<List<double>> _profit(InsightTimes time)async{
    List<double> data = [];
    String query = "SELECT invoice_has_stock.invoice_qty AS qty, stock.wholesale_price AS wholesalePrice, invoice_has_stock.invoice_unit_price AS unitPrice, invoice_has_stock.discount, invoice.invoice_date AS i_date FROM invoice_has_stock INNER JOIN stock ON stock.id = invoice_has_stock.stock_id INNER JOIN invoice ON invoice.invoice_id = invoice_has_stock.invoice_invoice_id WHERE invoice.invoice_date >= ':minDate' AND invoice.invoice_date < ':maxDate'";
    if(time == InsightTimes.daily){
      data.addAll(await _dailyProfit(query));
    }
    if(time == InsightTimes.weekly){
      data.addAll(await _weeklyProfit(query));
    }
    if(time == InsightTimes.monthly){
      data.addAll(await _monthlyProfit(query));
    }
    if(time == InsightTimes.yearly){
      data.addAll(await _yearlyProfit(query));
    }if(time == InsightTimes.total){
      data.addAll(await _totalProfit(query));
    }


    return data;
  }

  Future<List<double>> getData(
      {required InsightTimes selectedTime,
      required InsightModes selectedMode}) async {
    List<double> data = [];
    if (selectedMode == InsightModes.sales) {
      data.addAll(await _sales(selectedTime));
    }if(selectedMode == InsightModes.profit){
      data.addAll(await _profit(selectedTime));
    }

    return data;
  }
}
