/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package presentation;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Set;
import presentation.Fruit;
import presentation.Fruitstand;
import presentation.Orange;
import presentation.Strawberry;
import presentation.Banana;
import presentation.Grape;


/**
 *
 * @author wlovely
 */
public class Presentation {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        ripenFruit();
        
        System.out.println("\n\nSet up Fruitstand\n\n");
        
        setUpFruitstand();
    }
    
    public static void ripenFruit()
    {
        int i;
        Fruit fruit = new Fruit();

        fruit.setColor("red");
        
        System.out.println("The color of the fruit is " + fruit.getColor());

        while (fruit.goodToEat())
        {
            System.out.println("Yum! The fruit is good to eat");
            fruit.ripen(1);
        }

        for (i=0; i<4; i++)
        {
            fruit.ripen(1);
            System.out.println(fruit.riskEating());
        }        
    }
    
    public static void setUpFruitstand()
{
    Orange orange = new Orange();
    Strawberry strawberry = new Strawberry();
    Banana banana = new Banana();
    Grape grape = new Grape();
    
    Fruitstand stand = new Fruitstand();
    
    // We need some people to work the stand
    stand.operators.add("Bob");
    stand.operators.add("Carl");
    stand.operators.add("George");
        
    // Put a piece of fruit in each of the boxes
    stand.putFruitInBox(orange, "oranges");
    stand.putFruitInBox(strawberry, "strawberries");
    stand.putFruitInBox(banana, "banana");
    stand.putFruitInBox(grape, "grapes");
    

    System.out.println("\n\nWho is working the stand ?\n\n");

    // Let's see who is working
    stand.printOperators();
    
    System.out.println("\n\nCheck the inventory\n\n");
    
    // Let's enumerate what we have in the stand
    stand.printInventory();
    
    System.out.println("\n\nAdd fruit to stand\n\n");
    
    // Ok, let's stock the stand
    ArrayList boxNames = new ArrayList();
    boxNames.add("oranges");
    boxNames.add("strawberries");
    boxNames.add("banana");
    boxNames.add("grapes");
    
    Random randomGen = new Random();

    Iterator iterator = boxNames.iterator();
    
    while (iterator.hasNext())
    {
        String name = (String)iterator.next();
        
        for (int i=0; i<randomGen.nextInt(10); i++)
        {
            // statically compiled language so we can't just eval() our way to a fruit
            if (name.equals("oranges"))
            {
                Orange newOrange = new Orange();
                newOrange.setRindSmoothness("rough");
                newOrange.ripen(randomGen.nextInt(10));
                stand.putFruitInBox(newOrange, name);
            } else if (name.equals("strawberries"))
            {
                Strawberry berry = new Strawberry();
                berry.setExternalSeedDensity(randomGen.nextInt(10));
                berry.ripen(randomGen.nextInt(10));
                stand.putFruitInBox(berry, name);
            } else if (name.equals("banana"))
            {
                Banana newBanana = new Banana();
                newBanana.setPeelThickness(randomGen.nextInt(10));
                newBanana.ripen(randomGen.nextInt(10));
                stand.putFruitInBox(newBanana, name);
            } else if (name.equals("grapes"))
            {
                Grape newGrape = new Grape();
                grape.setSeedless(true);
                grape.ripen(randomGen.nextInt(10));
                stand.putFruitInBox(grape, name);
            }            
        }
    }
 
    System.out.println("\n\nRe-check the inventory\n\n");
    
    // Let's enumerate what we have in the stand
    stand.printInventory();
}}
