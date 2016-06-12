#include <fstream>
#include <iostream>

int main (int argc, char* argv[])
{
    if (argc != 3)
    {
        std::cout << "Usage: RandGen [number of values] [max value]" << std::endl;
        exit(1);
    }

    int maxNums = atoi(argv[1]);
    int maxValue = atoi(argv[2]);
    int randNum;

    std::ofstream outPutFile("rand.txt");
    for(int i = 0; i < maxNums; i++)
    {
        randNum = rand() % maxValue + 1;
        outPutFile << randNum << std::endl;
    }

    outPutFile.close();
}
