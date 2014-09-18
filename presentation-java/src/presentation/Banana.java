/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package presentation;

import presentation.Fruit;

/**
 *
 * @author wlovely
 */
public class Banana extends Fruit {
    private float peelThickness;
    
    public float getPeelThickness()
    {
        return this.peelThickness;
    }

    public void setPeelThickness(float thickness)
    {
        this.peelThickness = thickness;
    }
}