# Parallel exact and approximate Brute force algorithm

In this repository, we created a implementation of the parallel exact and approximate Brute force algorithm on CUDA. The code was made and tested for the NVIDIA GeForce GTX 1650 graphics card.

The exact native BF finds all patterns in a text with a 100% match in seconds even for files larger than 250 million characters, whereas the approximate BF, a.k.a. the k-mismatches algorithm, finds all patterns in a text with a 99% match. The largest computing time tested was for the pattern lenght of 1,000,000 characters, where the practical running time was about 35 minutes.

Contributors:
- [Begović Amila](https://github.com/abegovic6)  
- [Kaleta Senija](https://github.com/Senija)  
- [Leka Elma](https://github.com/eleka1)  
- [Panjeta Eldar](https://github.com/epanjeta)  
