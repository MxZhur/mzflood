const num mediumScreenSizeBreakpoint = 840;
const num smallScreenSizeBreakpoint = 600;

bool screenIsLarge(double input) => input >= mediumScreenSizeBreakpoint;
bool screenIsMedium(double input) =>
    input >= smallScreenSizeBreakpoint && input < mediumScreenSizeBreakpoint;
bool screenIsSmall(double input) => input < smallScreenSizeBreakpoint;
