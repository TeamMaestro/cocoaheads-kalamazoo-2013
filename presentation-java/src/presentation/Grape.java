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
public class Grape extends Fruit {

    private boolean seedless;

    public boolean isSeedless()
    {
        return this.seedless;
    }

    public void setSeedless(boolean hasSeeds)
    {
        this.seedless = hasSeeds;
    }
}
