using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MapGenerator.Models
{
    public partial class MapCellControl : UserControl
    {
        private Image? layer0;
        private Image? layer1;
        private bool block;

        public Image? Layer0 { get => layer0; set { layer0 = value; Refresh(); } }
        public Image? Layer1 { get => layer1; set { layer1 = value; Refresh(); } }
        public Image BlockImage { get; set; }
        public int? Layer0Index { get; set; }
        public int? Layer1Index { get; set; }
        public bool Block { get => block; set { block = value; Refresh(); } }

        public MapCellControl()
        {
            InitializeComponent();
            BlockImage = Image.FromFile("C:\\Users\\silve\\Documents\\GitHub\\gamingcampus-m1-lua-battletank\\assets\\ui\\cross.png");
        }

        private void MapCellControl_Paint(object sender, PaintEventArgs e)
        {
            if (Layer0 != null)
            {
                e.Graphics.DrawImage(Layer0, new Rectangle(0, 0, Width - 1, Height - 1));
            }
            if (Layer1 != null)
            {
                e.Graphics.DrawImage(Layer1, new Rectangle(0, 0, Width - 1, Height - 1));
            }
            if (Block)
            {
                e.Graphics.DrawImage(BlockImage, new Rectangle(0, 0, Width - 1, Height - 1));
            }
            e.Graphics.DrawRectangle(Pens.DarkGray, new Rectangle(0, 0, Width - 1, Height - 1));

        }
    }
}
