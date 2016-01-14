//
//  Eval.cpp
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/14.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#include "Eval.hpp"
#include <stack>
#include <sstream>
#include <vector>
using namespace std;

int operation1PriorToOperation2(string op1, string op2) {
    int a1 = -1, a2 = -1;
    if (op1 == "(") {
        a1 = 0;
    }
    if (op1 == "*" || op1 == "/") {
        a1 = 2;
    }
    if (op1 == "+" || op1 == "-") {
        a1 = 1;
    }
    if (op2 == "(") {
        a2 = 0;
    }
    if (op2 == "*" || op2 == "/") {
        a2 = 2;
    }
    if (op2 == "+" || op2 == "-") {
        a2 = 1;
    }
    if (a1 == -1 || a2 == -1) {
        return -1; //error
    }
    return a1 >= a2 ? 1 : 0;
}

bool isOperationSymbol(char c) {
    if (c == '+' || c == '-' || c == '*' || c == '/') {
        return true;
    }
    return false;
}

double evalSurfix(vector<string> surfix) {
    stack<double> workingStack;
    for (int i = 0; i < surfix.size(); i++) {
        std::cout << surfix[i];
        if (surfix[i] == "(") {
            return INT32_MAX;
        }
        if (surfix[i] == "+" || surfix[i] == "-" || surfix[i] == "*" || surfix[i] == "/") {
            if (workingStack.size() < 2) {
                return INT32_MAX;
            }
            double o1 = workingStack.top();
            workingStack.pop();
            double o2;
            if (workingStack.size()) {
                o2 = workingStack.top();
                workingStack.pop();
            }
            else {
                o2 = 0;
            }
            char op = surfix[i][0];
            switch (op) {
                case '+' :
                    workingStack.push(o1 + o2);
                    break;
                case '-' :
                    workingStack.push(o2 - o1);
                    break;
                case '*' :
                    workingStack.push(o1 * o2);
                    break;
                case '/' :
                    workingStack.push(o2 / o1);
                    break;
            }
        }
        else {
            double num = stod(surfix[i]);
            workingStack.push(num);
        }
    }
    return workingStack.top();
}

string eval(string s) {
    vector<string> suffixExpression;
    stack<string> workingStack;
    if (!s.size()) {
        return 0;
    }
    string number;
    for (int i = 0; i < s.length(); i++) {
        string c(1, s[i]);
        if (isspace(s[i])) {
            continue;
        }
        if (isdigit(s[i]) || s[i] == '.') {
            number = number + s[i];
        }
        else {
            if (number.length()) {
                suffixExpression.push_back(number);
                number = "";
            }
        }
        if (isOperationSymbol(s[i])) {
            while (!workingStack.empty()) {
                string stackTop = workingStack.top();
                if (operation1PriorToOperation2(stackTop, c)) {
                    workingStack.pop();
                    suffixExpression.push_back(stackTop);
                }
                else {
                    break;
                }
            }
            workingStack.push(c);
        }
        if (s[i] == '(') {
            workingStack.push(c);
        }
        if (s[i] == ')') {
            while (!workingStack.empty()) {
                string current = workingStack.top();
                workingStack.pop();
                if (current == "(") {
                    break;
                }
                suffixExpression.push_back(current);
            }
        }
    }
    if (number.length()) {
        suffixExpression.push_back(number);
    }
    while (!workingStack.empty()) {
        suffixExpression.push_back(workingStack.top());
        workingStack.pop();
    }
    double result = evalSurfix(suffixExpression);
    if (result == INT32_MAX) {
        return "error";
    }
    stringstream stringResult;
    stringResult << result;
    return stringResult.str();
}