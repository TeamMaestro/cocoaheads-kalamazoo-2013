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
public class Orange extends Fruit {

    private String rindSmoothness;

    public String getRindSmoothness()
    {
        return this.rindSmoothness;
    }

    public void setRindSmoothness(String smoothness)
    {
        this.rindSmoothness = smoothness;
    }
}
