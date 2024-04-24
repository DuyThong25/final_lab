import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab10/app/config/const.dart';
import 'package:lab10/app/data/api.dart';
import 'package:lab10/app/model/bill.dart';

class BillDetailWidget extends StatefulWidget {
  const BillDetailWidget({super.key, required this.idBill});
  final String idBill;
  @override
  State<BillDetailWidget> createState() => _BillDetailWidgetState();
}

class _BillDetailWidgetState extends State<BillDetailWidget> {
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
              } else {
                return Column(
                  children: [
                    const Text(
                      "Chi tiết đơn hàng",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return itemDetailBill(snapshot.data![index], index);
                        },
                      ),
                    )
                  ],
                );
              }
            }));
  }

  Widget itemDetailBill(BillDetailModel billDetailModel, int index) {
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
              billDetailModel.productName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            subtitle: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn giá ${formatVND(billDetailModel.price)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Số lượng: ${billDetailModel.count}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Tổng: ${formatVND(billDetailModel.total)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
            leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: (billDetailModel.imageURL! == null ||
                    billDetailModel.imageURL! == "")
                ? BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
            height: 65,
            width: 65,
            child: (billDetailModel.imageURL! == null ||
                    billDetailModel.imageURL! == "")
                ? const Icon(
                    Icons.image,
                    size: 35,
                  )
                : Image.network(
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    billDetailModel.imageURL!,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image,
                          size: 35,
                        )),
          ),
        ),
            // trailing: IconButton(
            //   icon: const Icon(Icons.highlight_remove_sharp),
            //   color: Colors.red,
            //   iconSize: 36,
            //   onPressed: () {},
            // ),
            onTap: () {},
          ),
        ));
  }
}
