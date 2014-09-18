/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// ~/NetBeansProjects/presentation/build/classes :) ] java presentation/Presentation
package presentation;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import presentation.Fruit;

/**
 *
 * @author wlovely
 */
public class Fruitstand {

    public ArrayList operators;
    public HashMap<String, ArrayList> fruitBoxes;
    
    Fruitstand()
    {
        this.operators = new ArrayList();
        this.fruitBoxes = new HashMap();
    }

    public void putFruitInBox(Fruit fruit, String destinationBox)
    {
        // make sure space was allocated to hold the array of fruits
        ArrayList box = this.fruitBoxes.get(destinationBox);
        if (box == null)
        {
            box = new ArrayList();
            this.fruitBoxes.put(destinationBox, box);
        }
        box.add(fruit);        
    }

    public void printOperators()
    {
        Iterator iterator = operators.iterator();

        while (iterator.hasNext()) 
        {
            String name = (String)iterator.next();
            System.out.println("Operator name = " + name);
        }        
    }

    public void printInventory()
    {
        for(String key : this.fruitBoxes.keySet()) {
            System.out.println("This box contains " + key);
            ArrayList box = this.fruitBoxes.get(key);

            int i = 0;
            Iterator iterator = box.iterator();
            while (iterator.hasNext())
            {
                Fruit fruit = (Fruit)iterator.next();
                i++;
                
                String classnameParts[] = fruit.getClass().toString().split("[.]");
                System.out.println("Fruit piece " +  i + ".  The diagnosis for this " + classnameParts[1] + " is: " + fruit.riskEating() + "\n\n");
            }
        }

    }
}
