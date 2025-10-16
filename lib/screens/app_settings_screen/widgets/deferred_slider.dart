import 'package:flutter/material.dart';

enum DeferredSliderType { singleValue, valueRange }

class DeferredSlider extends StatefulWidget {
  final double? currentValue;
  final RangeValues? currentValueRange;
  final double min;
  final double max;
  final int divisions;
  final DeferredSliderType sliderType;
  final void Function(double newValue)? onChangedValue;
  final void Function(RangeValues newRangeValue)? onChangedRange;

  final bool showThumbLabel;
  final bool roundThumbLabelValue;

  final String? labelLeft;
  final String? labelRight;
  final void Function()? onResetValue;
  final void Function()? onResetRange;

  const DeferredSlider({
    super.key,
    this.currentValue,
    this.currentValueRange,
    required this.sliderType,
    required this.min,
    required this.max,
    required this.divisions,
    this.onChangedValue,
    this.onChangedRange,
    this.labelLeft,
    this.labelRight,
    this.onResetValue,
    this.onResetRange,
    this.showThumbLabel = false,
    this.roundThumbLabelValue = false,
  });

  @override
  State<DeferredSlider> createState() => _DeferredSliderState();
}

class _DeferredSliderState extends State<DeferredSlider> {
  late double temporaryValue;
  late RangeValues temporaryRangeValue;

  @override
  void initState() {
    super.initState();
    if (widget.sliderType == DeferredSliderType.singleValue) {
      temporaryValue = widget.currentValue!;
    } else if (widget.sliderType == DeferredSliderType.valueRange) {
      temporaryRangeValue = widget.currentValueRange!;
    }
  }

  @override
  void didUpdateWidget(covariant DeferredSlider oldWidget) {
    super.didUpdateWidget(widget);

    if (widget.sliderType == DeferredSliderType.singleValue) {
      if (oldWidget.currentValue != widget.currentValue) {
        setState(() {
          temporaryValue = widget.currentValue!;
        });
      }
    } else if (widget.sliderType == DeferredSliderType.valueRange) {
      if (oldWidget.currentValueRange != widget.currentValueRange) {
        temporaryRangeValue = widget.currentValueRange!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (context) {
            if (widget.sliderType == DeferredSliderType.singleValue) {
              return Slider(
                value: temporaryValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChangeEnd: widget.onChangedValue,
                onChanged: (value) {
                  setState(() {
                    temporaryValue = value;
                  });
                },
                padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                label: widget.showThumbLabel
                    ? (widget.roundThumbLabelValue
                              ? temporaryValue.round()
                              : temporaryValue)
                          .toString()
                    : null,
              );
            } else if (widget.sliderType == DeferredSliderType.valueRange) {
              return RangeSlider(
                values: temporaryRangeValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChangeEnd: widget.onChangedRange,
                onChanged: (value) {
                  setState(() {
                    temporaryRangeValue = value;
                  });
                },
                padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                labels: widget.showThumbLabel
                    ? RangeLabels(
                        (widget.roundThumbLabelValue
                                ? temporaryRangeValue.start.round()
                                : temporaryRangeValue.start)
                            .toString(),
                        (widget.roundThumbLabelValue
                                ? temporaryRangeValue.end.round()
                                : temporaryRangeValue.end)
                            .toString(),
                      )
                    : null,
              );
            }

            return Container();
          },
        ),
        SizedBox(
          height: (TextTheme.of(context).labelMedium?.fontSize ?? 10) * 1.4,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              if (widget.labelLeft != null)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Text(
                    widget.labelLeft!,
                    style: TextTheme.of(context).labelMedium,
                  ),
                ),
              if (widget.labelRight != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Text(
                    widget.labelRight!,
                    style: TextTheme.of(context).labelMedium,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
