﻿using ejemplo1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace herencia
{
    internal class Program
    {
        static void Main(string[] args)
        {

            DateTime fecha = DateTime.Now;
            Console.WriteLine(fecha.ToString());


            Developer d1 = new Developer();
            Tester t1 = new Tester();
            Lider l1 = new Lider();


            Console.ReadKey();
        }
    }
}
