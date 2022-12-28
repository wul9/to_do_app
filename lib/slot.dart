import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Slot extends StatefulWidget {
  Slot(this.title, this.details, this.date, this.time, {super.key});
  String title;
  String details;
  String date;
  String time;
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
    return Ink(
        decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: Colors.blueGrey, width: 3)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text(
              widget.date,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              widget.time,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ]),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.black87, fontSize: 18),
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
  String title;
  String details;
  String date;
  String time;

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
        onChanged: (value) => setState(() => widget.title = value),
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
        onChanged: (value) => setState(() => widget.details = value),
        maxLines: null,
      ))
    ]);
  }
}

class SlotPage extends StatefulWidget {
  SlotPage(this.slot, {super.key});
  Slot slot;
  @override
  State<SlotPage> createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  @override
  void initState(){
    super.initState();
    Timer.periodic(const Duration(milliseconds: 50), (timer) => setState((){}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          widget.slot,
          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.slot.details,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ))),
        ],
      )),
      backgroundColor: Colors.black87,
    );
  }
}
