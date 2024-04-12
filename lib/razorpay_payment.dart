import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();
  
  void openCheckedOut(amount)async {
    amount = amount * 100;
    var options = {
      'key': '',
      'amount': amount,
      'name': 'Shyam Dave',
      'prefill': {'contact': '9876543210', 'email': 'abc@mail.com'},
      'external': { 'wallets': ['paytm', 'GooglePay']
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error : ${e.toString()}');
    }
  }
  
  void handlePaymentSuccess(PaymentSuccessResponse response)
  {
    Fluttertoast.showToast(msg: "Payment Done : ${response.paymentId}",toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response)
  {
    Fluttertoast.showToast(msg: "Payment Fail : ${response.message!}",toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response)
  {
    Fluttertoast.showToast(msg: "Payment Fail : ${response.walletName!}",toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            const Text(
              "Welcome to RazorPay Payment Gateway",
              style: TextStyle(
                  color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800
              ),
              textAlign: TextAlign.center,),
            const SizedBox(height: 50,),
            Padding(
              padding:const EdgeInsets.all(15.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: const TextStyle(color: Colors.white,fontSize: 22),
                decoration: const InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(color: Colors.white,fontSize: 15),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:Colors.green,
                        width:2.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                    errorStyle: TextStyle(color: Colors.red,fontSize: 22),

                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value==null || value.isEmpty)
                    {
                      return 'Please Enter Amount';
                    }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30,),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 10.0,bottom: 10.0),
                    backgroundColor:Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                ),
                onPressed: (){
                  if(amountController.text.toString().isNotEmpty)
                    {
                      setState(() {
                        int amount = int.parse(amountController.text.toString());
                        openCheckedOut(amount);
                      });
                    }
                },
                child: const Text("Pay",style: TextStyle(color:Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)
            )
          ],
        ),
      ),
    );
  }
}
