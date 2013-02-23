package es.olgierd.moto;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JSlider;
import javax.swing.JTable;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import CLIPSJNI.Environment;


class Iface extends JFrame  {

	private static final long serialVersionUID = 1L;
	private String makes[] = { "Honda", "duponda" };
	private String preferences[] = { "Obojetnie", "Dojazd", "Podroze", "PodrozeLong", "Wyscigi", "PojazdWyczynowy" };
	private String columnNames[] = { "Marka", "Model", "Ocena" };
	
	JLabel prefLabel;
	JLabel makeLabel;
	JLabel priceLabel;
	JLabel priceValueLabel;
	
	JComboBox<String> prefComboBox;
	JComboBox<String> makeComboBox;
	
	JSlider priceSlider;
	
	JButton calcButton;
	
	JTable results;
	
	Environment clips;
	
	
	void labelTable(JTable table) {
		
	}
	
	Iface() {
		
		this.setLayout(null);
			
		prefLabel = new JLabel("Preferowany rodzaj:");
		makeLabel = new JLabel("Preferowana marka:");
		priceLabel = new JLabel("Cena:");
		priceValueLabel = new JLabel();
		
		prefComboBox = new JComboBox<String>(preferences);
		makeComboBox = new JComboBox<String>(makes);
		
		calcButton = new JButton("Dopasuj");
		
		priceSlider = new JSlider(10, 110);
		priceSlider.setMajorTickSpacing(20);
		priceSlider.setPaintLabels(true);
		priceSlider.setPaintTicks(true);
		
		results = new JTable(null, columnNames );
		
		setupElements();
		
		clips = new Environment();
		clips.load("motory.clp");
		
	}
	
	void setupElements() {

		prefLabel.setBounds(10, 10, 150, 25);
		prefComboBox.setBounds(150, 10, 230, 25);

		makeLabel.setBounds(10, 40, 150, 25);
		makeComboBox.setBounds(150, 40, 230, 25);
		
		priceLabel.setBounds(10, 80, 150, 25);
		priceSlider.setBounds(150, 80, 230, 45);
		priceValueLabel.setBounds(60, 80, 150, 25);
		
		calcButton.setBounds(100, 150, 200, 25); 
		
		calcButton.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent arg0) {
				buttonClicked();
			}
		});
		
		priceSlider.addChangeListener(new ChangeListener() {
			@Override
			public void stateChanged(ChangeEvent arg0) {
				priceValueLabel.setText(Integer.toString(priceSlider.getValue()) + " tys. PLN");
			}
		});

		results.setBounds(10, 200, 380, 100);

		this.add(prefLabel);
		this.add(prefComboBox);
		
		this.add(makeLabel);
		this.add(makeComboBox);
		
		this.add(priceLabel);
		this.add(priceSlider);
		this.add(priceValueLabel);
		
		this.add(calcButton);
		
//		this.add(results);
		
	}
	
 	void buttonClicked() {
 		
 		String assertCommand = "";

 		String przeznaczenie = prefComboBox.getSelectedItem().toString();
 		String cena = Integer.toString(priceSlider.getValue());
 		String marka = makeComboBox.getSelectedItem().toString();
 		
 		System.out.println(przeznaczenie + " / " + cena + " / " + marka);
 		
 		assertCommand = "(assert (attribute (name NOWA_CENA) (value "+ "WYSCIGI"  +")))";
 		assertCommand = "(assert (attribute (name NOWA_MARKA) (value "+ "WYSCIGI"  +")))";
 		assertCommand = "(assert (attribute (name PRZEZNACZENIE) (value "+ "WYSCIGI"  +")))";
 		
 	}
	
}

public class MotoGui {

	public static void main(String[] argv) {
		
		System.out.println("Hello! ;)");

		
		JFrame window = new Iface();
		
		window.setSize(400, 400);
		window.setResizable(false);
		window.setVisible(true);
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		
	}
	
}
