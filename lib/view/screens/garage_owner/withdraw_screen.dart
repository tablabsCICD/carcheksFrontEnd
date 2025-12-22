import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../provider/withdrawal_provider.dart';
import '../../base_widgets/custom_appbar.dart';

class WithdrawalScreen extends StatefulWidget {
  final int garageId;
  const WithdrawalScreen({super.key, required this.garageId});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController amountCtrl = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final p = context.read<WithdrawalProvider>();
    p.fetchBalance(widget.garageId);
    p.fetchWithdrawals(widget.garageId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WithdrawalProvider>(
      builder: (context, p, _) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBarWidget(context, _scaffoldKey, "Appointment"),
          body: p.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _balanceCard(p),
                      const SizedBox(height: 20),
                      _withdrawInput(p),
                      const SizedBox(height: 24),
                      _withdrawalHistory(p),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _balanceCard(WithdrawalProvider p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Available Balance",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "\$ ${p.balance ?? 0}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Total Orders: ${p.totalOrders ?? 0}",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _withdrawInput(WithdrawalProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Withdraw Amount",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter amount",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: p.isSubmitting
                ? null
                : () async {
                    final amt = double.parse(amountCtrl.text);
                    await p.raiseWithdrawal(widget.garageId, amt);
                    amountCtrl.clear();
                  },
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF050A6C), Color(0xFF050A6C)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: p.isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Request Withdrawal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _withdrawalHistory(WithdrawalProvider p) {
    if (p.withdrawals.isEmpty) {
      return const Text("No withdrawal history");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Withdrawal History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: p.withdrawals.length,
          itemBuilder: (context, i) {
            final w = p.withdrawals[i];
            return Card(
              child: ListTile(
                title: Text("₹ ${w.requestedAmount}"),
                subtitle: Text(
                  "Commission: ₹${w.adminCommission} | Net: ₹${w.garageAmount}",
                ),
                trailing: Chip(
                  label: Text(w.status ?? ""),
                  backgroundColor: Colors.orange.shade100,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
