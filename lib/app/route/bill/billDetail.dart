import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/bill.dart';

class BillDetail extends StatefulWidget {
  const BillDetail({super.key, required this.idBill});
  final int idBill;
  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  Future<List<BillDetailModel>>? listBillDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listBillDetail = APIRepository().getBillByID(widget.idBill);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng"),
      ),
      body: FutureBuilder(
      future: listBillDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Lỗi"),
          );
        } else if (snapshot.data!.length == 0) {
          return const Center(
            child: Text(
              "Lỗi hiển thị thông tin !",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        else {
            return Placeholder();
          }
      }
      )
    );
  }
}