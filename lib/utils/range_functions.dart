bool isWithinRange<T extends num>(T input, T start, T end) =>
    input >= start && input <= end;

bool isWithinArrayRange(int index, int arrayLength) =>
    isWithinRange(index, 0, arrayLength - 1);

bool isOutOfArrayRange(int index, int arrayLength) =>
    !isWithinArrayRange(index, arrayLength);

bool isAtStartOfArrayRange(int index, int arrayLength) => index == 0;

bool isAtEndOfArrayRange(int index, int arrayLength) =>
    index == arrayLength - 1;

double mapRange(
  double input,
  double inputStart,
  double inputEnd,
  double outputStart,
  double outputEnd,
) =>
    outputStart +
    ((outputEnd - outputStart) / (inputEnd - inputStart)) *
        (input - inputStart);
