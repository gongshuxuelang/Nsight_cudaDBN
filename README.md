
作者：李春雪
时间：2019
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
我想到一个cuda不能使用cout函数的理由，那就是GPU并不是X86架构的，所以GPU并不能使用X86架构的函数，不仅仅是cout函数，应该是基于X86架构的一切函数都不可以使用，GPU只能使用GPU自己架构的函数，想要找现成的函数库，应该只能找NVIDIA公司提供的函数库，只能说NVIDIA公司压力不小，怎么能把C++ 这么多函数库移植到GPU设备上这才是重点。但是CUDA支持C++，应该是说的是从语法层次上说的，可以使用C++ 语法自己写算法，但是不可以使用C++标准库的函数。看来我想在GPU上使用boost库的想法是不能实现了，除非我自己移植我自己需要的boost库函数。

心情很是失落，但是总算明白了。

以下是感想，与题目无关，可以忽略这部分。

还有一点感慨就有，数据结构在这里体现出了他的价值，当你不能使用STL现成的算法，不能使用标准库函数，不能使用boost库函数的时候。当你还沉浸在不比重复造轮子的时候。突然这世间从未出现过轮子，一切事情都要从头开始做的时候，理论知识，数学推导，数据结构还有C++语言的技法，只有掌握了这些基本的知识，才能面对眼前的问题把。

我现在的处境就像是从一个现代社会一下子穿越回古代，我需要造一辆车，但是手头没有零部件，有的只有造零部件的工具。如何设计零部件，使用工具才是我面前真正的挑战。

这可能是我重新认识自己的一次机会，也是升华的一次机会。突破自己的屏障，做回一个真正的工匠，而不是熟练工。



