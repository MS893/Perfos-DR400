//TIP Pour <b>exécuter</b> un code, appuyer sur <shortcut actionId="Run"/> ou
// cliquez sur licône {0} dans la marge.
public class Main {
    public static void main(String[] args) {
        //TIP Appuyez sur <shortcut actionId="ShowIntentionActions"/> avec votre curseur dans le texte surligné
        // pour voir comment Android Studio suggère de le corriger.
        System.out.printf("Hello and welcome!");

        for (int i = 1; i <= 5; i++) {
            //TIP Appuyez sur <shortcut actionId="Debug"/> pour commencer à déboguer votre code. Nous avons défini <icon src="AllIcons.Debugger.Db_set_breakpoint"/> point darrêt
            // pour vous, vous pouvez à tout moment ajouter dautres points darrêt en pressant <shortcut actionId="ToggleLineBreakpoint"/>.
            System.out.println("i = " + i);
        }
    }
}