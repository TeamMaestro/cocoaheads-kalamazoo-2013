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
public class Strawberry extends Fruit {

    private int externalSeedDenisity;

    public int getExternalSeedDensity()
    {
        return this.externalSeedDenisity;
    }

    public void setExternalSeedDensity(int density)
    {
        this.externalSeedDenisity = density;
    }    
}