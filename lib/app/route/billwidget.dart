import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/bill.dart';
import 'package:lab10/app/route/bill/billDetailWidget.dart';
import 'package:lab10/mainpage.dart';

class BillDefault extends StatefulWidget {
  const BillDefault({super.key});

  @override
  State<BillDefault> createState() => _BillDefaultState();
}

class _BillDefaultState extends State<BillDefault> {
  Future<List<BillModel>>? listBillHistory;

  deleteBillItem(id) async {
    var respone = await APIRepository().removeBill(id);
    if (respone != "remove fail") {
      showToastMessage("Xóa thành công");
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => Mainpage(selectedIndex: 1)),
        (route) => true,
      );
      setState(() {});
    } else {
      showToastMessage("Lỗi xóa bill");
    }
  }

  showAlertDialog(onDelete, bool isDeleteAll, BillModel? bill) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    if (isDeleteAll) {
                      print("Xóa tất cả");
                    } else {
                      onDelete(bill!.id);
                    }
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listBillHistory = APIRepository().getHistoryBill();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listBillHistory,
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
              "Chưa có đơn hàng nào !",
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          return Column(
            children: [
              const Text(
                "Lịch sử đơn hàng",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // Dưa ngày mới nhất lên
                    snapshot.data!
                        .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
                    return itemBill(snapshot.data![index], index);
                  },
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget itemBill(BillModel bill, int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey, // Màu của đường viền
                width: 1.0, // Độ rộng của đường viền
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(6),
            title: Text(
              bill.dateCreated,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            subtitle: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khách hàng: ${bill.fullName}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  formatVND(bill.total),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.highlight_remove_sharp),
              color: Colors.red,
              iconSize: 36,
              onPressed: () {
                showAlertDialog(deleteBillItem, false, bill);
              },
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillDetailWidget(idBill: bill.id),
                  ));
            },
          ),
        ));
  }
}
