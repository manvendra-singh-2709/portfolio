import os
from ase.io import Trajectory

def convert_traj_to_csv():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    traj_files = [f for f in os.listdir(current_dir) if f.endswith('.traj')]
    
    for traj_file in traj_files:
        csv_filename = traj_file.replace('.traj', '.csv')
        title = traj_file.replace('.traj', '').replace('_', ' ')
        
        traj = Trajectory(traj_file)
        
        with open(csv_filename, 'w') as f:
            f.write(f"{title}\n")
            f.write("frame,symbol,x,y,z\n")
            
            for i, atoms in enumerate(traj):
                symbols = atoms.get_chemical_symbols()
                positions = atoms.get_positions()
                
                for j in range(len(atoms)):
                    f.write(f"{i},{symbols[j]},{positions[j][0]:.8f},{positions[j][1]:.8f},{positions[j][2]:.8f}\n")

if __name__ == "__main__":
    convert_traj_to_csv()