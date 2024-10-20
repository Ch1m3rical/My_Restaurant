#!/bin/bash


case $1 in
    "--analyser-ventes")
        INFILE=/home/wojtan_w/group-1040638/Restaurant/Ventes.csv


        while read -r LINE
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        cola_line=$(grep "Coca-Cola" $INFILE) 
        ventes_cola=$(echo "$cola_line" | cut -d"," -f"4")
        prix_cola=$(echo "$cola_line" | cut -d"," -f"5")
        gains_cola=$(echo "$prix_cola*$ventes_cola" | bc)


        pizza_line=$(grep "Pizza Margherita" $INFILE)
        vente_pizza=$(echo "$pizza_line" | cut -d"," -f"4")
        prix_pizza=$(echo "$pizza_line" | cut -d"," -f"5")
        gains_pizza=$(echo "$prix_pizza*$vente_pizza" | bc)


        gains_totaux=$(echo "$gains_cola+$gains_pizza" | bc)


        echo  Voici les profits des Coca-Cola : $gains_cola 
        echo  Voici les profits des Pizza Margherita : $gains_pizza 
        echo  Voici les profits Totals : $gains_totaux 


        if test "$gains_cola -ge $gains_pizza"; then
            echo  Les Coca-Colas etaient plus profitables 
        else
            echo  Les Pizza Margherita etaient plus profitables 
        fi 
    ;;

    "--gerer-stocks")
        INFILE=/home/wojtan_w/group-1040638/Restaurant/stocks.csv
        INFILE2=/home/wojtan_w/group-1040638/Restaurant/commandes_fournisseurs.csv


        while read -r LINE;
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        while read -r LINE2; 
        do
            printf '%s\n' "$LINE2"
        done < "$INFILE2"


        cola_dealer_line=$(grep "Fournisseur_Boissons" $INFILE2)
        cola_dealer_price=$(echo "$cola_dealer_line" | cut -d"," -f"6")
        cola_dealer_stock=$(echo "$cola_dealer_line" | cut -d"," -f"5")


        pizza_dealer_line=$(grep "Fournisseur_Pizza" $INFILE2)
        pizza_dealer_price=$(echo "$pizza_dealer_line" | cut -d"," -f"6")
        pizza_dealer_stock=$(echo "$pizza_dealer_line" | cut -d"," -f"5")

        pizza_line=$(grep "Pizza Margherita" $INFILE)
        stock_pizza=$(echo "$pizza_line" | cut -d"," -f"3")
        sc_pizza=$(echo "$pizza_line" | cut -d"," -f"6")
        

        cola_line=$(grep "Coca-Cola" $INFILE)
        stock_cola=$(echo "$cola_line" | cut -d"," -f"3")
        sc_cola=$(echo "$cola_line" | cut -d"," -f"6")


        if test $sc_pizza -ge $stock_pizza; then
            num_pizza="0"
            echo -e "Votre Stock de Pizza est inferieur au seuil critique \n vous avez $stock_pizza de pizza \n"
            read -p "Entrer le nombre de pizza : " num_pizza
            updated_pizza=$((num_pizza+stock_pizza))
            if test $updated_pizza -ge $sc_pizza; then
                echo -e "Voici le stock de pizza actuel $updated_pizza \n"
                new_pizza_dealer_stock=$((pizza_dealer_stock-num_pizza))
                sed -i "s|$stock_pizza|$updated_pizza|" $INFILE
                sed -i "s|$pizza_dealer_stock|$new_pizza_dealer_stock|" $INFILE2
                price_pizza_paid=$((pizza_dealer_price*num_pizza))
                echo -e "Voici le prix paye pour les pizza \n"
            fi
        else
            echo -e "Le seuil critique pas encore etait atteint \n"
        fi


        if test $sc_cola -ge $stock_cola; then
            num_cola="0"
            echo -e "Votre Stock de Cola est inferieur au seuil critique \n nous avez $stock_cola de cola \n"
            read -p "Entrer le nombre de pizza : " num_cola
            updated_cola=$((num_cola+stock_cola))
            if test $updated_cola -ge $sc_cola; then
                echo -e "Voici le stock de pizza actual $updated_cola \n"
                new_cola_dealer_stock=$((cola_dealer_stock-num_cola))
                sed -i "s|$stock_cola|$updated_cola|" $INFILE
                sed -i "s|$cola_dealer_stock|$new_cola_dealer_stock|" $INFILE2
                price_cola_paid=$((cola_dealer_price*num_cola))
                echo -e "Voici le prix paye pour les cola \n"
            fi
        else
            echo -e "Le seuil critique pas encore etait atteint \n"
        fi 
    ;;


     "--ajouter-employe")
        INFILE=/home/wojtan_w/group-1040638/Restaurant/employes.csv
        EMPLOYE_INFO=$2

        while read -r LINE;
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        if [ -z "$EMPLOYE_INFO" ]; then
            echo "Veuillez fournir les informations de l'employé sous la forme : \"nom,heures_travaillees,taux_horaire\""
        else
            echo "$EMPLOYE_INFO" >> "$INFILE"
            echo "L'employé a été ajouté avec succès."
        fi
    ;;


    "--calculer-salaires")
        INFILE=/home/wojtan_w/group-1040638/Restaurant/employes.csv

        while read -r LINE;
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        if [ ! -f "$INFILE" ]; then
            echo "Le fichier des employés n'existe pas. Veuillez ajouter des employés d'abord."
        else
            echo "Calcul des salaires des employés :"
            while IFS="," read -r id nom heures_travaillees taux_horaire
            do
                salaire=$(echo "$heures_travaillees * $taux_horaire" | bc)
                echo "Salaire de $nom : $salaire EUR"
            done < "$INFILE"
        fi
    ;;
    "--generer-rapport")
        
        INFILE=/home/wojtan_w/group-1040638/Restaurant/Ventes.csv
        INFILE2=/home/wojtan_w/group-1040638/Restaurant/stocks.csv
        INFILE3=/home/wojtan_w/group-1040638/Restaurant/employes.csv


        while read -r LINE;
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        while read -r LINE2;
        do
            printf '%s\n' "$LINE2"
        done < "$INFILE2"


        while read -r LINE3;
        do
            printf '%s\n' "$LINE3"
        done < "$INFILE3"

        total_revenue=0
        Total_cost=0

        tail -n +2 "$INFILE" | while IFS="," read -r id_vente date produit quantite prix_unitaire id_employe; do
            grep "Coca-Cola" $INFILE
            cola_produit_revenue=$(echo "$quantite * $prix_unitaire" | bc)
        done
        tail -n +2 "$INFILE" | while IFS="," read -r id_vente date produit quantite prix_unitaire id_employe; do
            grep "Pizza Margherita" $INFILE
            pizza_produit_revenue=$(echo "$quantite * $prix_unitaire" | bc)
        done
        total_revenue=$(echo "$pizza_produit_revenue + $cola_produit_revenue" | bc)

        tail -n +2 "$INFILE2" | while IFS="," read -r id_produit produit quantite_stock prix_achat prix_vente seuil_critique; do
            grep "Coca-Cola" $INFILE2
            produit_cost_cola=$(echo "$quantite_stock * $prix_achat" | bc)
        done
        tail -n +2 "$INFILE2" | while IFS="," read -r id_produit produit quantite_stock prix_achat prix_vente seuil_critique; do
            grep "Pizza Margherita" $INFILE2
            produit_cost_pizza=$(echo "$quantite_stock * $prix_achat" | bc)
        done
        total_cost=$(echo "$total_cost + $produit_cost" | bc)


        net_profit=$(echo "$total_revenue-$total_cost" | bc)


        total_hours=0


        echo "\nPerformance des employés :"
        tail -n +2 "$INFILE3" | while IFS="," read -r id_employe nom heures_travaillees taux_horaire; do
            salaire=$(echo "$heures_travaillees * $taux_horaire" | bc)
            employe1=$(grep "1" $INFILE3 | cut -d"," -f"3")
            employe2=$(grep "1" $INFILE3 | cut -d"," -f"3")
            total_hours=$(echo "$employe1 + $employe2" | bc)
            echo "Employé : $nom, Heures travaillées : $heures_travaillees, Salaire : $salaire EUR"
        done


        echo  "\nRapport Financier Quotidien:"
        echo  "Chiffre d'affaires total : $total_revenue EUR"
        echo  "Profit net : $net_profit EUR"
        echo  "Heures travaillées par tous les employés : $total_hours heures"
    ;;


     "--ajouter-vente")
        INFILE=/home/wojtan_w/group-1040638/Restaurant/Ventes.csv
        INFILE2=/home/wojtan_w/group-1040638/Restaurant/stocks.csv
        VENTE_INFO=$2

        while read -r LINE;
        do
            printf '%s\n' "$LINE"
        done < "$INFILE"


        while read -r LINE2;
        do
            printf '%s\n' "$LINE2"
        done < "$INFILE2"


        if [ -z "$VENTE_INFO" ]; then
            echo "Veuillez fournir les informations de la vente sous la forme : \"produit,quantite,prix_unitaire,id_employe\""
        else
            produit=$(echo "$VENTE_INFO" | cut -d"," -f1)
            quantite_vendue=$(echo "$VENTE_INFO" | cut -d"," -f2)
            prix_unitaire=$(echo "$VENTE_INFO" | cut -d"," -f3)
            id_employe=$(echo "$VENTE_INFO" | cut -d"," -f4)

            
            echo "$produit,$quantite_vendue,$prix_unitaire,$id_employe" >> "$INFILE"
            echo "La vente a été ajoutée avec succès à $INFILE."

            
            stock_line=$(grep "$produit" "$INFILE2")
            if [ -z "$stock_line" ]; then
                echo "Erreur: Le produit $produit n'existe pas dans le fichier des stocks."
            else
                stock_disponible=$(echo "$stock_line" | cut -d"," -f2)
                nouveau_stock=$((stock_disponible - quantite_vendue))

                if [ "$nouveau_stock" -lt 0 ]; then
                    echo "Erreur: La quantité vendue dépasse le stock disponible. Vente impossible."
                else
                    sed -i "s|$stock_line|$(echo "$stock_line" | sed "s|,$stock_disponible,|,$nouveau_stock,|")|" "$INFILE2"
                    echo "Le stock a été mis à jour. Nouveau stock de $produit : $nouveau_stock."
                fi
            fi
        fi
    ;;
esac