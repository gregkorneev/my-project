#include <iostream>
#include <string>
#include <stdexcept>
#include "rpn.h"

int main() {
    std::string expression;
    std::cout << "Enter RPN expression: ";
    if (!std::getline(std::cin, expression)) {
        std::cerr << "Error: failed to read input\n";
        return 1;
    }

    // убираем пробелы в начале и конце
    auto l = expression.find_first_not_of(" \t\r\n");
    if (l == std::string::npos) {
        std::cout << "Empty expression\n";
        return 0;
    }
    auto r = expression.find_last_not_of(" \t\r\n");
    expression = expression.substr(l, r - l + 1);

    try {
        double result = evaluate_rpn(expression);
        std::cout << "Result: " << result << std::endl;
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
