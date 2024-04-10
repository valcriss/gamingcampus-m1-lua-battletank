using MapGenerator.Models;
using Newtonsoft.Json;
using System;

namespace MapGenerator
{
    public partial class Form1 : Form
    {
        private MapData? MapData { get; set; } = null;
        private int? SelectedIndex { get; set; } = null;
        private Dictionary<int, string> AssetsFiles { get; set; } = new Dictionary<int, string>();

        public Form1()
        {
            InitializeComponent();
            LoadAssets();
            UpdateUI();
        }

        private void LoadAssets()
        {
            int index = 1;
            foreach (string file in Directory.GetFiles("C:\\Users\\silve\\Documents\\GitHub\\gamingcampus-m1-lua-battletank\\assets\\gamelevel\\tiles", "*.png"))
            {
                AssetsFiles.Add(index, "assets/gamelevel/tiles/" + Path.GetFileName(file));
                imageList1.Images.Add(Image.FromFile(file));
                index++;
            }
            index = 1;
            foreach (Image image in imageList1.Images)
            {
                var item = new ListViewItem(index.ToString(), index - 1) { Tag = index };
                assetList.Items.Add(item);
                index++;
            }
        }

        private void UpdateUI()
        {
            if (MapData == null)
            {
                sizeBox.Visible = true;
                loadButton.Visible = true;
                saveButton.Visible = false;
                assetsGroup.Visible = false;
                exportButton.Visible = false;
                layerGroup.Visible = false;
            }
            else
            {
                sizeBox.Visible = false;
                loadButton.Visible = false;
                saveButton.Visible = true;
                assetsGroup.Visible = true;
                exportButton.Visible = true;
                layerGroup.Visible = true;
            }
        }

        private void GenerateMap()
        {
            mapContainer.Controls.Clear();
            mapContainer.SuspendLayout();
            int start = 5;
            int cellSize = 25;
            List<MapCellControl> controls = new List<MapCellControl>();
            for (int y = 0; y < MapData.Height; y++)
            {
                for (int x = 0; x < MapData.Width; x++)
                {

                    MapCellControl pictureBox = new MapCellControl();
                    pictureBox.Name = "mapCell_" + x + "," + y;
                    pictureBox.BackColor = Color.Transparent;
                    pictureBox.Location = new Point(start + (x * cellSize), start + (y * cellSize));
                    pictureBox.Size = new Size(cellSize, cellSize);
                    pictureBox.MouseDown += PictureBox_MouseDown;
                    pictureBox.Block = false;
                    pictureBox.Tag = 0;
                    controls.Add(pictureBox);
                }
            }
            mapContainer.Controls.AddRange(controls.ToArray());
            mapContainer.ResumeLayout();
        }

        private void PictureBox_MouseDown(object? sender, MouseEventArgs e)
        {
            bool layer0 = radioL0.Checked;
            bool layer1 = radioL1.Checked;
            if (sender is MapCellControl pictureBox)
            {
                if (e.Button == MouseButtons.Right)
                {
                    if (layer0)
                    {
                        pictureBox.Layer0 = null;
                        pictureBox.Layer0Index = 0;
                    }
                    else if (layer1)
                    {

                        pictureBox.Layer1 = null;
                        pictureBox.Layer1Index = 1;
                    }
                    else
                    {
                        pictureBox.Block = false;
                    }
                }
                else if (SelectedIndex != null)
                {
                    int index = SelectedIndex.Value;
                    Image image = imageList1.Images[index];
                    if (layer0)
                    {
                        pictureBox.Layer0 = image;
                        pictureBox.Layer0Index = index;
                    }
                    else if (layer1)
                    {
                        pictureBox.Layer1 = image;
                        pictureBox.Layer1Index = index;
                    }
                    else
                    {
                        pictureBox.Block = true;
                    }
                }
            }
        }

        private void generate_Click(object sender, EventArgs e)
        {
            MapData = new MapData((int)width.Value, (int)height.Value);
            GenerateMap();
            UpdateUI();
        }

        private void assetList_ItemSelectionChanged(object sender, ListViewItemSelectionChangedEventArgs e)
        {
            SelectedIndex = e.ItemIndex;
        }

        private void UpdateMapData()
        {
            if (MapData == null) return;
            MapData.TilesAssets = AssetsFiles;
            int index = 1;
            MapData.Layer0.Clear();
            MapData.Layer1.Clear();
            MapData.Block.Clear();

            foreach (MapCellControl cell in mapContainer.Controls)
            {
                MapData.Layer0.Add(index, cell.Layer0Index);
                MapData.Layer1.Add(index, cell.Layer1Index);
                MapData.Block.Add(index, cell.Block);

                index++;
            }
        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            UpdateMapData();
            string content = JsonConvert.SerializeObject(MapData);
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(saveFileDialog1.FileName, content);
            }
            MessageBox.Show("Saved !");
        }

        private void loadButton_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string content = File.ReadAllText(openFileDialog1.FileName);
                MapData = JsonConvert.DeserializeObject<MapData>(content);
                GenerateMap();
                UpdateUI();
                UpdateMapContent();
            }
        }

        private void UpdateMapContent()
        {
            if (MapData == null) return;

            int index = 1;
            foreach (MapCellControl cell in mapContainer.Controls)
            {
                int? layer0 = MapData.Layer0[index];
                int? layer1 = MapData.Layer1[index];
                if (layer0 != null)
                {
                    cell.Layer0 = imageList1.Images[layer0.Value];
                    cell.Layer0Index = layer0.Value;
                }
                if (layer1 != null)
                {
                    cell.Layer1 = imageList1.Images[layer1.Value];
                    cell.Layer1Index = layer1.Value;
                }
                cell.Block = MapData.Block[index];
                index++;
            }
        }

        private void exportButton_Click(object sender, EventArgs e)
        {
            if (MapData == null) return;

            UpdateMapData();

            ExportMapData export = new ExportMapData(MapData.Width, MapData.Height);
            export.Block = MapData.Block.FilterFalse();
            export.Layer0 = MapData.Layer0.FilterNull();
            export.Layer1 = MapData.Layer1.FilterNull();
            export.TilesAssets = MapData.TilesAssets.FilterUnused(MapData.Layer0, MapData.Layer1);
            string content = JsonConvert.SerializeObject(export);
            if (saveFileDialog2.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(saveFileDialog2.FileName, content);
            }
            MessageBox.Show("Exported !");
            UpdateMapData();
        }
    }
}
