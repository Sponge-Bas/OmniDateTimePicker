import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/omni_datetime_picker_bloc.dart';
import 'components/calendar/calendar.dart';
import 'components/custom_scroll_behavior.dart';
import 'components/time_picker_spinner/time_picker_spinner.dart';
import 'enums/omni_datetime_picker_type.dart';
import 'package:intl/intl.dart';

class OmniDateTimePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final ValueChanged<DateTime> onDateTimeChanged;

  final String? amText;
  final String? pmText;
  final bool isShowSeconds;
  final bool is24HourMode;
  final int minutesInterval;
  final int secondsInterval;
  final bool isForce2Digits;
  final bool looping;
  final bool horizontalLayout;

  final Widget selectionOverlay;

  final Widget? separator;
  final OmniDateTimePickerType type;

  const OmniDateTimePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    required this.onDateTimeChanged,
    this.amText,
    this.pmText,
    this.isShowSeconds = false,
    this.is24HourMode = false,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.isForce2Digits = true,
    this.looping = true,
    this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
    this.separator,
    this.type = OmniDateTimePickerType.dateAndTime,
    this.horizontalLayout = false,
  });

  @override
  State<OmniDateTimePicker> createState() => _OmniDateTimePickerState();
}

class _OmniDateTimePickerState extends State<OmniDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final defaultInitialDate = DateTime.now();
    final defaultFirstDate = DateTime.fromMillisecondsSinceEpoch(0);
    final defaultLastDate = DateTime(2100);
    final ValueNotifier<String> summary = ValueNotifier<String>("now");

    return BlocProvider(
      create: (context) => OmniDatetimePickerBloc(
        initialDateTime: widget.initialDate ?? defaultInitialDate,
        firstDate: widget.firstDate ?? defaultFirstDate,
        lastDate: widget.lastDate ?? defaultLastDate,
      ),
      child: BlocConsumer<OmniDatetimePickerBloc, OmniDatetimePickerState>(
        listener: (context, state) {
          widget.onDateTimeChanged(state.dateTime);
          Duration delta = state.dateTime.difference(DateTime.now());
          if (delta.inMinutes < 0) {
            summary.value = "Please select a date in the future";
          } else if (delta.inMinutes < 1) {
            summary.value = "now";
          } else {
            String newSummary = "";
            if (delta.inDays.floor() > 0) {
              newSummary += "${delta.inDays.floor()} days, ";
            }
            newSummary +=
                "${delta.inHours.remainder(24)}:${NumberFormat("00").format(delta.inMinutes.remainder(60))} hours from now";
            summary.value = newSummary;
          }
        },
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: Flex(
              mainAxisSize: MainAxisSize.max,
              direction:
                  widget.horizontalLayout ? Axis.horizontal : Axis.vertical,
              children: [
                if (widget.type == OmniDateTimePickerType.dateAndTime ||
                    widget.type == OmniDateTimePickerType.date)
                  Expanded(
                    child: Calendar(
                      initialDate: state.dateTime,
                      firstDate: state.firstDate,
                      lastDate: state.lastDate,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      onDateChanged: (datetime) {
                        context
                            .read<OmniDatetimePickerBloc>()
                            .add(UpdateDate(dateTime: datetime));
                      },
                    ),
                  ),
                if (widget.separator != null) widget.separator!,
                if (widget.type == OmniDateTimePickerType.dateAndTime ||
                    widget.type == OmniDateTimePickerType.time)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TimePickerSpinner(
                          amText: widget.amText ??
                              localizations.anteMeridiemAbbreviation,
                          pmText: widget.pmText ??
                              localizations.postMeridiemAbbreviation,
                          isShowSeconds: widget.isShowSeconds,
                          is24HourMode: widget.is24HourMode,
                          minutesInterval: widget.minutesInterval,
                          secondsInterval: widget.secondsInterval,
                          isForce2Digits: widget.isForce2Digits,
                          looping: widget.looping,
                          selectionOverlay: widget.selectionOverlay,
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: summary,
                          builder: (context, value, _) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                              child: RichText(
                                text: TextSpan(
                                  text: value,
                                  style: TextStyle(
                                    color: Color(0xFF575757),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.70,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
