#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

bool isIntegralNumber(const std::string& s) {
    if (s.empty()) return false;
    size_t start = (s[0] == '-') ? 1 : 0;
    return s.length() > start && std::all_of(s.begin() + start, s.end(), ::isdigit);
}

bool isFloatingPointNumber(const std::string& s) {
    if (s.empty()) return false;
    size_t start = (s[0] == '-') ? 1 : 0;
    return std::count(s.begin() + start, s.end(), '.') == 1 &&
           std::all_of(s.begin() + start, s.end(), [](char c) { return ::isdigit(c) || c == '.'; }) &&
           s.back() != '.';
}

int getArgumentPosition(const std::string& candidate, const std::vector<std::string>& args) {
    auto it = std::find(args.begin(), args.end(), candidate);
    return it != args.end() ? std::distance(args.begin(), it) + 1 : -1;
}

std::string getValidInput(const std::string& prompt, bool (*validator)(const std::string&)) {
    std::string input;
    bool wrong = false;

    do {
        if (wrong)
            std::cout << "  wrong candidate, try again: ";
        else
            std::cout << prompt;
        std::cin  >> input;
        wrong = true;
    } while (!validator(input));
    return input;
}

void printArgumentPosition(int position) {
    std::cout << "  position: " << (position == -1 ? "not found" : std::to_string(position)) << std::endl;
}

int main(int argc, char *argv[]) {
    std::vector<std::string> args(argv + 1, argv + argc);

    std::string candidate;

    candidate = getValidInput("Integral number: ", isIntegralNumber);
    printArgumentPosition(getArgumentPosition(candidate, args));

    candidate = getValidInput("\nFloating point number: ", isFloatingPointNumber);
    printArgumentPosition(getArgumentPosition(candidate, args));

    std::cout << "\nString: ";
    std::cin  >> candidate;
    printArgumentPosition(getArgumentPosition(candidate, args));

    return 0;
}
