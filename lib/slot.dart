import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Slot extends StatefulWidget {
  Slot(this.title, this.details, this.date, this.time, {super.key});
  String title, details, date, time;
  bool selected = false;
  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    ManagerSlot managerSlot = ManagerSlot(
        title: widget.title,
        time: widget.time,
        date: widget.date,
        details: widget.details);
    return ClipRRect(borderRadius:BorderRadius.circular(6),child: ExpansionTile(
        collapsedBackgroundColor: Colors.black,
        backgroundColor: Colors.black,
        collapsedIconColor: Colors.white,
        expandedAlignment: Alignment.center,
        title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: widget.selected
                          ? const Icon(
                              Icons.check_box,
                              color: Colors.white,
                            )
                          : const Icon(Icons.check_box_outline_blank,
                              color: Colors.white),
                      onPressed: () =>
                          setState((() => widget.selected = !widget.selected))),
                  Expanded(
                      child: Text(
                    overflow: TextOverflow.ellipsis,
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: 10,
                  )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.date,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          widget.time,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        )
                      ]),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                              ),
                              content: managerSlot,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.title = managerSlot.title;
                                        widget.details = managerSlot.details;
                                        widget.date = managerSlot.date;
                                        widget.time = managerSlot.time;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'))
                              ],
                            )),
                  ),
                ]),
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height/4,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.details,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )))
        ]));
  }
}

class ManagerSlot extends StatefulWidget {
  ManagerSlot(
      {this.title = '',
      this.details = '',
      this.date = '',
      this.time = '',
      super.key});
  String title, details, date, time;

  @override
  State<ManagerSlot> createState() => _ManagerSlotState();
}

class _ManagerSlotState extends State<ManagerSlot> {
  DateTime? date = DateTime.now();
  TimeOfDay? time = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
          child: TextFormField(
        initialValue: widget.title,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Title'),
        onChanged: (value) => widget.title = value,
        maxLines: 1,
      )),
      const Padding(padding: EdgeInsets.all(16), child: Text('')),
      Row(
        children: const [
          Padding(
              padding: EdgeInsets.only(right: 40, left: 40),
              child: Text('Pick Date',
                  style: TextStyle(color: Colors.black87, fontSize: 18))),
          Text('Pick Time',
              style: TextStyle(color: Colors.black87, fontSize: 18))
        ],
      ),
      Row(
        children: [
          Flexible(
            child: TextButton.icon(
                icon: const Icon(Icons.calendar_month, color: Colors.black87),
                label: Text(widget.date,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 18)),
                onPressed: () async {
                  date = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 20),
                    lastDate: DateTime(DateTime.now().year + 20, 12, 31),
                  ));
                  date != null
                      ? setState(
                          () => widget.date = DateFormat('yMd').format(date!))
                      : widget.date;
                }),
          ),
          Flexible(
            child: TextButton.icon(
                icon: const Icon(Icons.schedule, color: Colors.black87),
                label: Text(widget.time,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 18)),
                onPressed: () async {
                  time = (await showTimePicker(
                      context: context, initialTime: TimeOfDay.now()));
                  if (!mounted) return;
                  time != null
                      ? setState(() => widget.time = time!.format(context))
                      : widget.time;
                }),
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.all(16), child: Text('')),
      Flexible(
          child: TextFormField(
        initialValue: widget.details,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Details'),
        onChanged: (value) => widget.details = value,
        maxLines: null,
      ))
    ]);
  }
}

