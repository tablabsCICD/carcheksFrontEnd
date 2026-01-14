import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/settlement_provider.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GarageReport extends StatefulWidget {
  //final int garageId;
  const GarageReport({super.key});

  @override
  State<GarageReport> createState() => _GarageReportState();
}

class _GarageReportState extends State<GarageReport> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<SettlementProvider>();
    final garageProvider = context.read<GarageProvider>();
    int garageId = garageProvider.ownGarageList[0].id;

    provider.fetchAvailableBalance(garageId);
    provider.fetchWithdrawalHistory(garageId);
  }

  @override
  Widget build(BuildContext context) {
    final garageProvider = context.read<GarageProvider>();
    int garageId = garageProvider.ownGarageList[0].id;
    return Scaffold(
      appBar: CustomAppBarWidget(context, GlobalKey(), "My Earnings"),
      body: Consumer<SettlementProvider>(
        builder: (context, model, _) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _balanceCard(model),
                const SizedBox(height: 20),
                _withdrawButton(model, garageId),
                const SizedBox(height: 30),
                _historyTitle(),
                const SizedBox(height: 10),
                _withdrawHistory(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _balanceCard(SettlementProvider model) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Available Balance",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "\$ ${model.availableAmount}",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("${model.totalOrders} Orders"),
          ],
        ),
      ),
    );
  }

  Widget _withdrawButton(SettlementProvider model, int garageId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: model.availableAmount <= 0
            ? null
            : () => model.requestSettlement(garageId),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.deepPurple,
        ),
        child: const Text(
          "Request Settlement",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _historyTitle() {
    return const Text(
      "Withdrawal History",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _withdrawHistory(SettlementProvider model) {
    if (model.withdrawalHistory.isEmpty) {
      return const Center(child: Text("No withdrawals yet"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.withdrawalHistory.length,
      itemBuilder: (context, index) {
        final item = model.withdrawalHistory[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: Text("\$ ${item.garageAmount}"),
            subtitle: Text(
              "Requested on ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(item.requestedAt))}",
            ),
            trailing: Chip(
              label: Text(item.status),
              backgroundColor: item.status == "REQUESTED"
                  ? Colors.orange.shade100
                  : Colors.green.shade100,
            ),
          ),
        );
      },
    );
  }
}
