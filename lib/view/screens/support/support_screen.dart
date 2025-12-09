import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../provider/feddback_provider.dart';
import '../../base_widgets/custom_appbar.dart';
import '../../../provider/review_provider.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ---------- STATUS COLORS ----------
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
      case "completed":
        return Colors.green;
      case "pending":
      case "requested":
        return Colors.orange;
      case "rejected":
      case "closed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ---------- STATUS ICON ----------
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
      case "completed":
        return Icons.check_circle;
      case "pending":
      case "requested":
        return Icons.hourglass_top;
      case "rejected":
      case "closed":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => Provider.of<FeedbackProvider>(context, listen: false)
            .getFeedbackByUserId());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          key: _scaffoldKey,
          appBar:
          CustomAppBarWidget(context, _scaffoldKey, "Support / HelpDesk"),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- SUBJECT ----------------
                const Text("Subject:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    hintText: "Enter subject...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // ---------------- MESSAGE ----------------
                const Text("Message:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Describe your issue...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // ---------------- SUBMIT BUTTON ----------------
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    if (subjectController.text.isEmpty ||
                        messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    await provider.saveFeedback(
                      title: subjectController.text,
                      message: messageController.text,
                    );

                    await provider.getFeedbackByUserId();
                    subjectController.clear();
                    messageController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text("Feedback submitted successfully")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                ),

                const SizedBox(height: 25),
                const Text("Submitted Feedback",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // ---------------- FEEDBACK LIST ----------------
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        provider.getFeedbackByUserId(), // pull to refresh
                    color: Colors.green,
                    child: provider.feedbackList.isEmpty
                        ? const Center(child: Text("No feedback yet"))
                        : AnimationLimiter(
                      child: ListView.builder(
                        itemCount: provider.feedbackList.length,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          final item = provider.feedbackList[index];
                          final statusColor =
                          getStatusColor(item.status ?? "");
                          final statusIcon =
                          getStatusIcon(item.status ?? "");

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              child: FadeInAnimation(
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  margin:
                                  const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      )
                                    ],
                                    border: Border.all(
                                        color: statusColor, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // SUBJECT + STATUS ICON
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.subject ?? "",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                          Icon(statusIcon,
                                              color: statusColor,
                                              size: 22),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // MESSAGE
                                      Text(
                                        item.message ?? "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),

                                      const SizedBox(height: 14),

                                      // ---------------- TIMELINE ----------------
                                    /*  _buildTimeline(item.status ?? ""),

                                      const SizedBox(height: 10),
*/
                                      // STATUS BADGE
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6),
                                          decoration: BoxDecoration(
                                            color: statusColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item.status ?? "",
                                            style: TextStyle(
                                                color: statusColor,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ****************************************************
  //          HORIZONTAL TIMELINE WIDGET
  // ****************************************************
  Widget _buildTimeline(String status) {
    bool step1 = true; // created always true
    bool step2 = status.toLowerCase() != "requested";
    bool step3 = status.toLowerCase() == "resolved" ||
        status.toLowerCase() == "completed";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _timelineCircle("Created", step1, Colors.blue),
        _timelineDivider(),
        _timelineCircle("In Progress", step2, Colors.orange),
        _timelineDivider(),
        _timelineCircle("Completed", step3, Colors.green),
      ],
    );
  }

  Widget _timelineCircle(String title, bool active, Color activeColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: active ? activeColor : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(title,
            style: TextStyle(
              fontSize: 12,
              color: active ? activeColor : Colors.grey,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            )),
      ],
    );
  }

  Widget _timelineDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey.shade300,
      ),
    );
  }
}
