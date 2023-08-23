using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace herencia3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            /*
            Gato g1 = new Gato();
            g1.Nombre = "Pepe";
            Console.WriteLine(g1.comunicarse());
            Tigre t1 = new Tigre();
            Console.WriteLine("---------------");
            
            List<Animal> animales = new List<Animal>();
            animales.Add(g1);
            animales.Add(t1);
            animales.Add(new AnimalDomestico());
            animales.Add(new AnimalSalvaje());
            animales.Add(new Animal());

            foreach (Animal animal in animales)
            {
                Console.WriteLine(animal.comunicarse());
            }

            Animal a1 = g1;
            Gato g2 = (Gato)a1; //Recasteo como un gato aunque antes lo haya casteado
            //como un animal
            */

            //Ahora, puedo hacer una lista con una interfaz
            List<Flyable> listaVoladores = new List<Flyable>();
            listaVoladores.Add(new Pajaro());
            //Puedo agarrarle cualquier objeto que implemente una interfaz
            Console.ReadKey();
        }
    }
}
