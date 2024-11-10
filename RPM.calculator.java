import java.util.Scanner;

public class Calculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter first number: ");
        double num1 = scanner.hasNextDouble() ? scanner.nextDouble() : 0.0;  // Default value if no input

        System.out.print("Enter second number: ");
        double num2 = scanner.hasNextDouble() ? scanner.nextDouble() : 0.0;  // Default value if no input

        System.out.println("Choose operation: +, -, *, /");
        String operation = scanner.hasNext() ? scanner.next() : "+";  // Default operation if no input

        double result = 0;
        switch (operation) {
            case "+":
                result = num1 + num2;
                break;
            case "-":
                result = num1 - num2;
                break;
            case "*":
                result = num1 * num2;
                break;
            case "/":
                if (num2 != 0) {
                    result = num1 / num2;
                } else {
                    System.out.println("Cannot divide by zero");
                }
                break;
            default:
                System.out.println("Invalid operation");
        }
        System.out.println("Result: " + result);
        scanner.close();
    }
}
