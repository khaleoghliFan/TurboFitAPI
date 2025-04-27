def palin(x):
    return x[::-1]

print(palin([1,2,4]))

# Palindromic numbers from 1 to 100000

def palindromic_numbers():
    return [i for i in range(1, 100001) if str(i) == str(i)[::-1]]

###def second_largest(nums):
def second_largest(nums):
    first = second = None
    for n in nums:
        if n > first:
            second = first
            first = n
        elif first > n > second:
            second = n
    return second

##
import random
def fibo(n,memo={}):
    if n in memo:
        return memo[n]
    if n<=1:
        return n
    memo[n]=fibo(n-1,memo) + fibo(n-2,memo)
    return memo[n]

print(fibo(9))
