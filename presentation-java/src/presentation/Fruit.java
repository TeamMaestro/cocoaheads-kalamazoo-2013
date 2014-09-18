/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentation;

/**
 *
 * @author wlovely
 */
public class Fruit {
    private String color;
    private int ripeness;
    
    public String getColor()
    {
        return this.color;
    }
    
    public void setColor(String color)
    {
        this.color = color;
    }
    
    public int getRipeness()
    {
        return this.ripeness;
    }
    
    public void ripen(int intensity)
    {
        ripeness += intensity;
    }

    public boolean goodToEat()
    {
        if (ripeness >= 5)
        {
            return false;
        } else {
            return true;
        }
    }

    public String riskEating()
    {
        String ret;
        
        if (ripeness<5)
        {
            ret = "Yum !";
        } else {
            switch (ripeness)
            {
                case 5:
                    ret = "It will be ok";
                    break;
                case 6:
                    ret = "Maybe it's not so bad";
                    break;
                case 7:
                    ret = "I really don't want to go to the store, here it goes :O";
                    break;
                default:
                    ret = "Guess it is time to toss it :(";
            }
        }
        return ret;
    }

}
