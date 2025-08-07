#include <iostream>
#include <vector>
#include <stdexcept>
#include <climits>

bool is_prime(unsigned int n);
unsigned int next_prime(unsigned int n);
bool is_twin_prime(unsigned int n);
std::vector<unsigned> primes_in_range(unsigned start, unsigned end);

bool is_prime(unsigned int n)
{
    if (n < 2)
    {
        throw std::invalid_argument{ "Cannot be lower then 2\n" };
    }

    const unsigned int sqrtN = std::sqrt(n);

    if (n % 2 == 0) return n == 2;
    for (unsigned i = 3; i <= sqrtN; i += 2)
    {
        if (n % i == 0) return false;
    }
    return true;
}

unsigned int next_prime(unsigned int n)
{
    if (n >= std::numeric_limits<unsigned>::max() - 1) // Добавил проверку на переполнение
    {
        throw std::overflow_error("Next prime cannot be unsigned int!\n");
    }

    unsigned int currentTemp = std::min(n + 1, std::numeric_limits<unsigned>::max());
    while (not is_prime(currentTemp))
    {
        if (currentTemp > std::numeric_limits<unsigned>::max() - 100)
        {
            throw std::overflow_error("Stack overflow!\n");
        }
        currentTemp++;
    }
    return currentTemp;
}

bool is_twin_prime(unsigned int n)
{
    if (n > std::numeric_limits<unsigned>::max() - 2) return false;
    return is_prime(n) && is_prime(n + 2);
}

std::vector<unsigned> primes_in_range(unsigned start, unsigned end)
{
    if (start > end) // добавил
    {
        unsigned int temp = start;
        start = end;
        end = temp;
    }

    if (end == std::numeric_limits<unsigned>::max()) end--;

    if (2 > start) // добавил
    {
        start = 2;
    }

    std::vector<unsigned> primes = {};
    std::vector<bool> sieve(end + 1, true);
    sieve[0] = sieve[1] = false;
    for (unsigned i = 4; i <= end; i += 2) sieve[i] = false;  // Чётные
    for (unsigned i = 3; i * i <= end; i += 2) {
        if (sieve[i]) {
            for (unsigned j = i * i; j <= end; j += 2 * i) {
                sieve[j] = false;
            }
        }
    }


    for (unsigned i = start; i <= end; i++)
    {
        if (sieve[i])
        {
            primes.push_back(i);
        }
    }

    return primes;
}

int main()
{
    long checkNumber, checkStart, checkEnd; // для проверки
    unsigned int number, pairNumber, start, end;
    do // Для ввода только unsigned int
    {
        std::cout << "Enter the number : ";
        std::cin >> checkNumber;

        if (checkNumber < 0 || checkNumber > std::numeric_limits<unsigned>::max())
        {
            std::cout << "Number is out of range! Enter the number again\n";
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            continue;
        }
        number = checkNumber;
        break;
    } while (true);


    try
    {
        if (is_prime(number))
        {
            std::cout << number << " is prime\n";
        }
    }
    catch (std::invalid_argument error)
    {
        std::cout << error.what();
    }

    try
    {
        pairNumber = next_prime(number);
        std::cout << "next prime : " << pairNumber << "\n";
    }
    catch (std::overflow_error error)
    {
        std::cout << error.what();
    }

    try
    {
        if (is_prime(pairNumber))
        {
            std::cout << pairNumber << " is prime\n";
        }
    }
    catch (std::invalid_argument error)
    {
        std::cout << error.what();
    }

    if (is_twin_prime(number))
    {
        std::cout << number << " and " << pairNumber << " are twin primes\n";
    }

    do // Для ввода только unsigned int
    {
        std::cout << "enter a range of prime numbers : \n";
        std::cin >> checkStart;

        if (checkStart < 0 || checkStart > std::numeric_limits<unsigned>::max())
        {
            std::cout << "Number is out of range! Enter the number again\n";
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            continue;
        }
        start = checkStart;
        break;
    } while (true);

    do // Для ввода только unsigned int
    {
        std::cin >> checkEnd;

        if (checkEnd < 0 || checkEnd > std::numeric_limits<unsigned>::max())
        {
            std::cout << "Number is out of range! Enter the number again\n";
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            continue;
        }
        end = checkEnd;
        break;
    } while (true);

    std::vector<unsigned> primes = primes_in_range(start, end);
    std::cout << "Prime numbers from the range: [";


    if (primes.size() > 1)
    {
        for (int i = 0; i < primes.size() - 1; i++)
        {
            std::cout << primes[i] << ", ";
        }
    }
    if (primes.size() > 0)
    {
        std::cout << primes[primes.size() - 1];
    }
    std::cout << "]\n";

    return 0;
}
